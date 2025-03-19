class Todo < ApplicationRecord

  after_create :broadcast_create_todo
  after_create :broadcast_scroll
  after_update :broadcast_update_todo
  after_destroy :broadcast_destroy_todo
  
  private

  def broadcast_update_todo
    Turbo::StreamsChannel.broadcast_replace_to(
      "todos",
      target: "todo_#{id}",
      partial: "todos/component/todo",
      locals: { todo: self }
    )
  end

  def broadcast_create_todo
    Turbo::StreamsChannel.broadcast_append_to(
      "todos",
      target: "todos",
      partial: "todos/component/todo",
      locals: { todo: self }
    )
  end

  def broadcast_destroy_todo
    Turbo::StreamsChannel.broadcast_remove_to(
      "todos",
      target: "todo_#{id}"
    )
  end

  def broadcast_scroll
    Turbo::StreamsChannel.broadcast_action_to(
      "todos",
      action: "scroll_to_bottom",
      target: "todos"
    )
  end
end
