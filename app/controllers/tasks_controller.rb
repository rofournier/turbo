class TasksController < ApplicationController
  before_action :cancel_running_task, only: %i[create start]

  def index
    @all_tasks = current_user.tasks.includes(:task_sessions).order(created_at: :desc)
    @running_tasks = current_user.tasks.includes(:task_sessions).incomplete.order(created_at: :desc)
    @completed_tasks = current_user.tasks.includes(:task_sessions).completed.order(created_at: :desc)
  end

  def edit
    @task = Task.find(params[:id])
  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(create_params)
    colour = "000000"
    @task.color = "##{colour}"
    @task.user = current_user
    @task.save!
    @task_session = TaskSession.create(task: @task, started_at: Time.current)
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
    @task_session = TaskSession.create(task: @task, started_at: Time.current)
    @task.update(running: true, last_started_at: Time.current)
  end

  def stop
    @task = Task.find(params[:id])
    @ts = @task.task_sessions.current.first
    @ts.update(ended_at: Time.current, running: false)
    time_spent = @task.time_spent + @ts.time_spent
    @task.update(running: false, time_spent: time_spent)
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

    # Filter tasks by current week and include task sessions
    @all_tasks = current_user.tasks.includes(:task_sessions).where(created_at: start_date..end_date).order(created_at: :desc)
    @running_tasks = current_user.tasks.includes(:task_sessions).incomplete.where(created_at: start_date..end_date).order(created_at: :desc)
    @completed_tasks = current_user.tasks.includes(:task_sessions).completed.where(created_at: start_date..end_date).order(created_at: :desc)
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
    @running_task = Task.current.first
    if @running_task.present?
      @running_task&.update(running: false)
      @running_task&.task_sessions.current.first.update(ended_at: Time.current, running: false) if @running_task&.task_sessions.current.present?
    end
  end
end
