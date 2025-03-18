class Message < ApplicationRecord

  after_create :broadcast_message
  
  private

  def broadcast_message
    Turbo::StreamsChannel.broadcast_append_to(
      "chat",
      target: "messages",
      partial: "messages/component/message",
      locals: { message: self }
    )

    Turbo::StreamsChannel.broadcast_action_to(
      "chat",
      action: "scroll_to",
      target: "messages"
    )
  end
  
end
