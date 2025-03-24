class Task < ApplicationRecord
  belongs_to :user
  has_many :task_sessions, dependent: :destroy

  after_create_commit :broadcast_create_task
  after_create_commit :broadcast_scroll

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :current, -> { where(running: true) }

  private

  def broadcast_create_task
    Turbo::StreamsChannel.broadcast_append_to(
      "tasks_#{self.user.id}",
      target: "tasks_#{self.user.id}",
      partial: "tasks/component/task",
      locals: { task: self }
    )
  end

  def broadcast_scroll
    Turbo::StreamsChannel.broadcast_action_to(
      "tasks_#{self.user.id}",
      action: "scroll_to_bottom",
      target: "tasks_#{self.user.id}"
    )
  end
end
