# frozen_string_literal: true

class SendAdminCommunicationTemplate
  def self.call(users:, job:, communcation_template:, type:, support_user: User.main_support_user) # rubocop:disable Metrics/LineLength
    template = communcation_template
    data = {}
    if job
      job.attributes.symbolize_keys.each { |key, value| data[:"job_#{key}"] = value }
      data[:job_name] = job.name
      data[:job_description] = job.description
    end

    response = MessageUsersFromTemplateService.call(
      type: type,
      users: users,
      template: template,
      data: data
    ) do |user, body, language_id|
      chat = Chat.find_or_create_private_chat([support_user, user])
      chat.create_message(author: support_user, body: body, language_id: language_id)
    end
    response
  end
end
