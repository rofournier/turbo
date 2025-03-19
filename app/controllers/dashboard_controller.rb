class DashboardController < ApplicationController
  def index
    @todo = Todo.new
    @todos = Todo.all
    @messages = Message.all
    @tasks = current_user.tasks
  end
end
