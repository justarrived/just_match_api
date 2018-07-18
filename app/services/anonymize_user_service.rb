# frozen_string_literal: true

class AnonymizeUserService
  Result = Struct.new(:anonymized?, :user, keyword_init: true)

  def self.call(user, force: false, run_async: true, notify: false)
    if !force && !user.anonymization_allowed?
      return Result.new(anonymized?: false, user: user)
    end

    document_ids = []
    email = user.email

    user.anonymize_attributes
    user.save!

    # Remove user content
    user.translations.each(&:destroy!)

    # Remove application message - just in case the user has entered any PPI there
    user.job_users.each do |job_user|
      job_user.set_translation(apply_message: '<The user has been deleted.>')
    end

    user.recruiter_activities.each do |ra|
      document_ids << ra.document_id if ra.document_id
      ra.destroy!
    end
    user.digest_subscriber(&:mark_destroyed)&.save!

    # Remove user documents
    user.user_documents.each do |ud|
      document_ids << ud.document_id
      ud.destroy!
    end

    ExecuteService.call(RemoveDocumentService.to_s, document_ids, run_async: run_async)
    ExecuteService.call(RemoveUserImagesService.to_s, user, run_async: run_async)

    if notify
      DeliverNotification.call(
        UserMailer.anonymization_performed_confirmation_email(email: email),
        user.locale
      )
    end

    Result.new(anonymized?: true, user: user)
  end
end
