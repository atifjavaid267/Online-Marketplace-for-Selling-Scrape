class MessagesController < ApplicationController
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

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

      time = Time.now.strftime('%B %d, %Y %I:%M %p')

      ActionCable.server.broadcast('room_channel_1', {
                                     sender_id: sender,
                                     receiver_id: receiver,
                                     message: message_content,
                                     timestamp: time
                                   })
      # @notification = Notification.create(sender: @message.sender_id,
      #                                     receiver: @message.receiver_id)
      # @notification_id = @notification.id
    else
      # handle errors here
      puts @message.errors.full_messages
    end
    respond_to do |format|
      format.js { render(js: "") }
    end
  end
  # def create
  #   @message = Message.new(message_params)

  #   if @message.save
  #     sender = @message.sender_id
  #     receiver = @message.receiver_id
  #     message_content = @message.content
  #     time = Time.now.strftime('%B %d, %Y %I:%M %p')

  #     ActionCable.server.broadcast('room_channel_1', {
  #                                    sender_id: sender,
  #                                    receiver_id: receiver,
  #                                    message: message_content,
  #                                    timestamp: time
  #                                  })

  #     # Create or update the Notification record
  #     @notification = Notification.find_or_initialize_by(
  #       sender: @message.sender_id,
  #       receiver: @message.receiver_id
  #     )
  #     @notification.count += 1
  #     @notification.read = false
  #     @notification.save

  #     respond_to do |format|
  #       format.js {}
  #     end
  #   else
  #     # handle errors here
  #     puts @message.errors.full_messages
  #   end
  # end
  private

  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :content)
  end
end
