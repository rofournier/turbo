class TasksController < ApplicationController
  before_action :cancel_running_task, only: %i[create start]

  def index
    @tasks = Task.all
  end

  def create
    @task = Task.new(create_params)
    @task.last_started_at = Time.current
    @task.user = current_user
    @task.save!
  end

  def start
    @task = Task.find(params[:id])
    @task.update(running: true, last_started_at: Time.current)
  end

  def stop
    @task = Task.find(params[:id])
    time_spent = @task.time_spent + (Time.current - @task.last_started_at).to_i
    @task.update(time_spent: time_spent)
    @task.update(running: false)
  end

  def destroy
    @task = Task.find(destroy_params[:id])
    @task.destroy
  end

  private

  def create_params
    params.require(:task).permit(:name)
  end

  def destroy_params
    params.permit(:id)
  end

  def cancel_running_task
    return unless @running_task = Task.find_by(running: true)
    time_spent = @running_task.time_spent + (Time.current - @running_task.last_started_at).to_i
    @running_task.update(time_spent: time_spent)
    @running_task = Task.cancel_running
  end
end
