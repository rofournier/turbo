class TasksController < ApplicationController
  before_action :cancel_running_task, only: %i[create start]

  def index
    @all_tasks = current_user.tasks.order(created_at: :desc)
    @running_tasks = current_user.tasks.incomplete.order(created_at: :desc)
    @completed_tasks = current_user.tasks.completed.order(created_at: :desc)
  end

  def create
    @task = Task.new(create_params)
    @task.last_started_at = Time.current
    colour = "%06x" % (rand * 0xffffff)
    @task.color = "##{colour}"
    @task.user = current_user
    @task.save!
  end

  def update
    @task = Task.find(params[:id])
    @task.update(update_params)
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

  def complete
    @task = Task.find(params[:id])
    @task.update(completed: true)
  end

  def restore
    @task = Task.find(params[:id])
    @all_tasks = current_user.tasks.order(created_at: :desc)
    @task.update(completed: false)
  end

  def destroy
    @task = Task.find(destroy_params[:id])
    @task.destroy
  end

  private

  def create_params
    params.require(:task).permit(:name)
  end

  def update_params
    params.require(:task).permit(:name, :color)
  end

  def destroy_params
    params.permit(:id)
  end

  def cancel_running_task
    return if Task.find_by(running: true) == nil
    @running_task = Task.cancel_running
    time_spent = @running_task.time_spent + (Time.current - @running_task.last_started_at).to_i
    @running_task.update(time_spent: time_spent)
  end
end
