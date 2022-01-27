class MessageDeletionJob < ApplicationJob
  queue_as :default

  def perform(message)
    # Do something later
    message.destroy!
  end
end
