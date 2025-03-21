class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  has_many :tasks, dependent: :destroy
  has_one :setting, dependent: :destroy

  after_create :create_default_setting

  def username
    email.split('@').first
  end

  private

  def create_default_setting
    settings = {
      "theme" => "light",
      "widgets" => {
      "chat" => {
        "name" => "messages/component/chat_card",
        "visible" => true,
        "color" => "#99C1F1", # light blue
        "order" => 1,
      },
      "todo" => {
        "name" => "todos/component/todo_card",
        "visible" => true,
        "color" => "#A3D9A5", # light green
        "order" => 2,
      },
      "tracker" => {
        "name" => "tasks/component/tracker_card",
        "visible" => true,
        "color" => "#F1A3A3", # light red
        "order" => 3,
      },
      "board" => {
        "name" => "board/component/board_card",
        "visible" => true,
        "color" => "#F1E099", # light yellow
        "order" => 4,
      },
      "radio" => {
        "name" => "radio/component/radio_card",
        "visible" => true,
        "color" => "#D1A3F1", # light purple
        "order" => 5,
      }
      }
    }

    Setting.create(user: self, config: settings.to_json)

  end
end
