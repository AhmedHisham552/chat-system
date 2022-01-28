class EntityUpdateJob < ApplicationJob
  queue_as :default

  def perform(inst,params)
    # Do something later
    inst.update(params)
  end
end
