# frozen_string_literal: true
class MessageUsersFromTemplate
  def self.call(type:, users:, template:, data: {})
    new(type, users, template, data).call
  end

  def initialize(type, users, template, data)
    @type = type
    @users = users
    @template = template
    @data = data
  end

  def call
    @users.each do |user|
      I18n.with_locale(user.locale) do
        translation = @template.find_translation(locale: user.locale)
        response = MessageUser.call(
          type: @type,
          user: user,
          template: translation.body,
          subject: translation.subject,
          data: @data
        )
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
