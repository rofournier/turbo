class Task < ApplicationRecord

  belongs_to :user
  
  after_create_commit :broadcast_create_task
  after_create_commit :broadcast_scroll

  scope :running, -> { where(running: true) }

  private

  def broadcast_create_task
    Turbo::StreamsChannel.broadcast_append_to(
      "tasks_#{self.user.id}",
      target: "tasks_#{self.user.id}",
      partial: "tasks/component/task",
      locals: { task: self }
    )
  end

  def self.cancel_running
    running_task = Task.find_by(running: true)
    running_task&.update(running: false)
    running_task
  end

  def broadcast_scroll
    Turbo::StreamsChannel.broadcast_action_to(
      "tasks_#{self.user.id}",
      action: "scroll_to_bottom",
      target: "tasks_#{self.user.id}"
    )
  end

end

