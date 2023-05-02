class MessagesController < ApplicationController

  load_and_authorize_resource

  def index
    @messages = Message.all
  end

  def show; end

  def new
    @order = Order.find(params[:order_id])
  end

  def create
    @message = Message.new(message_params)

    # @messages = Message.all.length
    if @message.save
      sender = @message.sender_id
      receiver = @message.receiver_id
      message_content = @message.content

      time = Time.now.strftime("%B %d, %Y %I:%M %p")

      ActionCable.server.broadcast('room_channel_1', {
                                     sender_id: sender,
                                     receiver_id: receiver,
                                     message: message_content,
                                     timestamp: time
                                   })
    else
      # handle errors here
      puts @message.errors.full_messages
    end
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :content)
  end
end
