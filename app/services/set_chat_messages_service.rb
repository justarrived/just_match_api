# frozen_string_literal: true

module SetChatMessagesService
  def self.call(chat:, message_ids_param:)
    return Message.none if message_ids_param.blank?

    chat_messages_params = normalize_message_ids(message_ids_param)
    chat_messages_params.map do |attrs|
      # Don't bother changing records that already have been saved
      next if attrs[:id].present?

      Message.new.tap do |m|
        m.chat = chat
        m.language_id = attrs[:language_id]
        m.author_id = attrs[:author_id]
        m.body = attrs[:body]
        if m.save!
          m.set_translation(body: attrs[:body])
          author = m.author
          ProcessTranslationJob.perform_later(translation: m.original_translation)
          NewChatMessageNotifier.call(chat: chat, message: m, author: author)
        end
      end
    end.compact
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
