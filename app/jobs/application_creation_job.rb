class ApplicationCreationJob < ApplicationJob
  queue_as :default

  def perform(token, name)
    # Do something later
    application = ChatApplication.new(token: token, name: name)
    application.save!
  end
end
