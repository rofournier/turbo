class DashboardController < ApplicationController
  def index
    @todo = Todo.new
    @todos = Todo.all
    @messages = Message.all
  end
end
