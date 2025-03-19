class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def create
    @messages = Message.all
    @message = Message.create!(create_params.merge(sender: current_user.username))
  end

  private

  def create_params
    params.require(:message).permit(:body)
  end

  def destroy_params
    params.permit(:id)
  end
end
