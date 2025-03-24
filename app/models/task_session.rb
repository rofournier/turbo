class TaskSession < ApplicationRecord

  scope :current, -> { where(running: true) }

  belongs_to :task

  def time_spent
    if ended_at.present?
      (ended_at - started_at).to_i
    else
      (Time.current - started_at).to_i
    end
  end
end
