class ChatCreationJob < ApplicationJob
  queue_as :default

  def perform(appId,chatNumber)
    # Do something later
    chat = Chat.new(chat_application_id: appId,application_chat_number: chatNumber)
    chat.save!
  end
end
