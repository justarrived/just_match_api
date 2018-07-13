# frozen_string_literal: true

class CreateUserService
  def self.call(**args)
    new(**args).call
  end

  attr_reader :user, :params, :password, :consent, :language_ids, :skill_ids,
              :interest_ids, :image_tokens, :occupation_ids

  def initialize(params:, password:, consent:, language_ids:, skill_ids:, interest_ids:, image_tokens:, occupation_ids:) # rubocop:disable Metrics/LineLength
    @params = params
    @password = password
    @consent = consent
    @language_ids = language_ids
    @skill_ids = skill_ids
    @interest_ids = interest_ids
    @occupation_ids = occupation_ids
    @image_tokens = image_tokens
    @user = User.new(params)
  end

  def call
    user.password = password

    user.validate

    unless accepted_terms?
      consent_error = I18n.t('errors.user.must_consent_to_terms_of_agreement')
      user.errors.add(:consent, consent_error)
      return user
    end

    return user unless user.valid?

    begin
      commit!
      user
    rescue ActiveRecord::RecordInvalid,
           ActiveRecord::Rollback,
           ActiveRecord::StatementInvalid,
           ActiveRecord::RecordNotSaved => e

      context = { user_id: user.id }
      ErrorNotifier.send('User creation failed', exception: e, context: context)
      user
    end
  end

  def commit!
    user.save!

    set_user_translations
    user.set_images_by_tokens = image_tokens if image_tokens.present?

    SetUserTraitsService.call(
      user: user,
      language_ids_param: language_ids,
      skill_ids_param: skill_ids,
      interest_ids_param: interest_ids,
      occupation_ids_param: occupation_ids
    )

    send_welcome_notification
    push_to_frilans_finans
    enqueue_digest_subscriber_sync
    user
  end

  def accepted_terms?
    [true, 'true'].include?(consent)
  end

  def set_user_translations
    user.set_translation(params)
  end

  def send_welcome_notification
    UserWelcomeNotifier.call(user: user) if user.candidate?
  end

  def update_welcome_app_status
    if AppConfig.welcome_app_active?
      UpdateUserWelcomeAppStatusJob.perform_later(user: user)
    end
  end

  def push_to_frilans_finans
    if AppConfig.frilans_finans_active?
      SyncFrilansFinansUserJob.perform_later(user: user)
    end
  end

  def enqueue_digest_subscriber_sync
    DigestSubscriberSyncJob.perform_later(user: user)
  end
end
