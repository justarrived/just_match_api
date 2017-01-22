# frozen_string_literal: true
module SetChatMessagesService
  def self.call(chat:, message_ids_param:)
    return Message.none if message_ids_param.nil? || message_ids_param.empty?

    chat_messages_params = normalize_message_ids(message_ids_param)
    chat_messages_params.map do |attrs|
      message = Message.find_or_initialize_by(chat: chat, id: attrs[:id])
      message.language_id = attrs[:language_id]
      message.author_id = attrs[:author_id]
      message.body = attrs[:body]
      message.set_translation(body: attrs[:body]) if message.save
      message
    end
  end

  def self.normalize_message_ids(message_ids_param)
    message_ids_param.map do |message|
      if message.respond_to?(:permit)
        message.permit(:id, :language_id, :author_id, :body)
      elsif message.is_a?(Hash)
        message
      end
    end
  end
end
