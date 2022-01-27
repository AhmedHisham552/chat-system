class ChatDeletionJob < ApplicationJob
  queue_as :default

  def perform(chat)
    # Do something later
    chat.destroy!
  end
end
