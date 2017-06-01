# frozen_string_literal: true

class MessageUsersFromTemplate
  def self.call(type:, users:, template:, data: {}, &block)
    new(type, users, template, data, &block).call
  end

  def initialize(type, users, template, data, &block)
    @type = type
    @users = users
    @template = template
    @data = data
    @block = block
  end

  def call
    @users.each do |user|
      I18n.with_locale(user.locale) do
        translation = @template.find_translation(locale: user.locale)
        language_id = translation.language_id

        response = MessageUser.call(
          type: @type,
          user: user,
          template: translation.body,
          subject: translation.subject,
          data: @data
        ) do |subject, message|
          @block&.call(user, [subject, message].join("\n\n"), language_id)
        end
        return response unless response[:success]
      end
    end

    { success: true, message: "Sending #{type_name} to #{@users.length} user(s)." }
  end

  def type_name
    return 'both sms and email' if @type == 'both'
    @type
  end
end
