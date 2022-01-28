class EntityDeletionJob < ApplicationJob
  queue_as :default

  def perform(inst)
    # Do something later
    inst.destroy!
  end
end
