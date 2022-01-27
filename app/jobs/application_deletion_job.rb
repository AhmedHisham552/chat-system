class ApplicationDeletionJob < ApplicationJob
  queue_as :default

  def perform(app)
    # Do something later
    app.destroy!
  end
end
