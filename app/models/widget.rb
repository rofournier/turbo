class Widget < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true
  
  def self.for_user(user)
    widgets = where(user: user)
    
    # Default widgets if no settings exist yet
    default_widgets = [
      { "name" => "board/component/board_card", "title" => "Board", "visible" => true },
      { "name" => "tasks/component/tracker_card", "title" => "Task Tracker", "visible" => true },
      { "name" => "todos/component/todo_card", "title" => "Todo List", "visible" => true },
      { "name" => "messages/component/chat_card", "title" => "Chat", "visible" => true }
    ]
    
    if widgets.empty?
      default_widgets.each do |widget|
        create(name: widget["name"], user: user, visible: widget["visible"])
      end
      widgets = where(user: user)
    end
    
    widgets.map { |w| { "name" => w.name, "title" => w.name.split('/').last.humanize, "visible" => w.visible } }
  end
end
