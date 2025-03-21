class TasksController < ApplicationController
  before_action :cancel_running_task, only: %i[create start]

  def index
    @all_tasks = current_user.tasks.order(created_at: :desc)
    @running_tasks = current_user.tasks.incomplete.order(created_at: :desc)
    @completed_tasks = current_user.tasks.completed.order(created_at: :desc)
  end

  def edit
    @task = Task.find(params[:id])
  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(create_params)
    @task.last_started_at = Time.current
    colour = "000000"
    @task.color = "##{colour}"
    @task.user = current_user
    @task.save!
  end

  def update
    @task = Task.find(params[:id])
    time_spent = if params[:task][:hours].present? || params[:task][:minutes].present?
             (params[:task][:hours].to_i * 3600) + (params[:task][:minutes].to_i * 60)
    else
             @task.time_spent
    end
    @task.update(update_params.except(:hours, :minutes).merge(time_spent: time_spent))
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

  def week_view
    # Get current week's date range (Monday to Sunday)
    start_date = Date.current.beginning_of_week
    end_date = Date.current.end_of_week
    
    # Filter tasks by current week
    @all_tasks = current_user.tasks.where(created_at: start_date..end_date).order(created_at: :desc)
    @running_tasks = current_user.tasks.incomplete.where(created_at: start_date..end_date).order(created_at: :desc)
    @completed_tasks = current_user.tasks.completed.where(created_at: start_date..end_date).order(created_at: :desc)
  
  end

  def edit_name
    @task = Task.find(params[:id])
  end
  

  private

  def create_params
    params.require(:task).permit(:name)
  end

  def update_params
    params.require(:task).permit(:name, :color, :hours, :minutes)
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
