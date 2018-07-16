# frozen_string_literal: true

class AnonymizeUserService
  def self.call(user, force: false, delete_document_inline: false)
    if !force && !user.anonymization_allowed?
      return Result.new(anonymized?: false, user: user)
    end

    user.anonymize_attributes
    user.save!

    # Remove user content
    user.translations.each(&:destroy!)

    # Remove application message - just in case the user has entered any PPI there
    user.job_users.each do |job_user|
      job_user.set_translation(apply_message: '<The user has been deleted.>')
    end

    user.feedbacks.each(&:destroy!)
    user.digest_subscriber(&:mark_destroyed)&.save!

    # Remove user documents
    document_ids = user.user_documents.map do |ud|
      ud.destroy!
      ud.document_id
    end

    if delete_document_inline
      RemoveDocumentService.call(document_ids)
    else
      RemoveDocumentsJob.perform_later(ids: document_ids)
    end

    Result.new(anonymized?: true, user: user)
  end
end
