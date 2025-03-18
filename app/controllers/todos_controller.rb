class TodosController < ApplicationController
  def index
    @todos = Todo.all.order(created_at: :desc)
  end

  def create
    @todos = Todo.all.order(created_at: :desc)
    @todo = Todo.create!(create_params)
  end

  def destroy
    @todo = Todo.find(destroy_params[:id])
    @todo.destroy!
  end

  def strike
    @todo = Todo.find(update_params[:id])
    @todo.update!(done: !@todo.done)
  end

  private

  def create_params
    params.require(:todo).permit(:name)
  end

  def update_params
    params.permit(:id)
  end

  def destroy_params
    params.permit(:id)
  end
end
