class DashboardController < ApplicationController
  def index
    @todo = Todo.new
    @todos = Todo.all
    @messages = Message.all
    @tasks = current_user.tasks
    @settings = JSON(current_user.setting.config)
    @ordered_widgets = @settings["widgets"].values.sort_by { |widget| widget["order"] }
    @setting = Setting.new
    @radios = [
      {
        name: "Nolife",
        url: "https://listen.nolife-radio.com/stream"
      },
      {
        name: "Culture",
        url: "http://direct.franceculture.fr/live/franceculture-midfi.mp3"
      },
      {
        name: "Metal",
        url: "https://radio3.pro-fhi.net/live/Radio Metal"
      }
    ]
  end
end
