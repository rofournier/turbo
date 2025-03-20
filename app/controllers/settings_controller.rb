class SettingsController < ApplicationController
  def update
    @settings = JSON(current_user.setting.config)
    @widget_key = params[:id]
    
    payload = JSON.parse(request.body.read)
    @property_to_update = payload[@widget_key].keys.first
    @new_value = payload[@widget_key][@property_to_update]
    
    if @property_to_update == "visible"
      @new_value = ActiveModel::Type::Boolean.new.cast(@new_value)
    elsif @property_to_update == "order"
      @new_value = @new_value.to_i
    end

    @settings["widgets"][@widget_key][@property_to_update] = @new_value
    current_user.setting.update(config: @settings.to_json)

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
