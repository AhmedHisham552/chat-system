class MessageCreationJob < ApplicationJob
  queue_as :default

  def perform(chatId, messageNumber, body)
    # Do something later
    message = Message.new(chat_id: chatId,chat_message_number: messageNumber,body: body)
    message.save!
  end
end
