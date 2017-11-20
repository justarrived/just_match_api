# frozen_string_literal: true

class UpdateUserService
  def self.call(**args)
    new(**args).call
  end

  attr_reader :user, :params, :old_email

  def initialize(user:, params:, language_ids:, skill_ids:, interest_ids:, occupation_ids:) # rubocop:disable Metrics/LineLength
    @user = user
    @params = params
    @old_email = @user.email

    @language_ids = language_ids
    @skill_ids = skill_ids
    @interest_ids = interest_ids
    @occupation_ids = occupation_ids
  end

  def call
    return user unless user.update(params)

    set_translations

    user.reload

    enqueue_email_updated_events unless user.email == old_email
    set_user_traits
    enqueue_ff_user_sync

    user
  end

  def set_translations
    user.set_translation(params).tap do |result|
      ProcessTranslationJob.perform_later(
        translation: result.translation,
        changed: result.changed_fields
      )
    end
  end

  def enqueue_email_updated_events
    DigestSubscriberSyncJob.perform_later(user: user)
  end

  def set_user_traits
    SetUserTraitsService.call(
      user: user,
      language_ids_param: @language_ids,
      skill_ids_param: @skill_ids,
      interest_ids_param: @interest_ids,
      occupation_ids_param: @occupation_ids
    )
  end

  def enqueue_ff_user_sync
    return unless AppConfig.frilans_finans_active?

    SyncFrilansFinansUserJob.perform_later(user: user)
  end
end
