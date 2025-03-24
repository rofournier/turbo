class TodosController < ApplicationController

  def broadcast
    ActionCable.server.broadcast 'DrawingChannel', "Hello from the Rails app."
  end

  private


end
