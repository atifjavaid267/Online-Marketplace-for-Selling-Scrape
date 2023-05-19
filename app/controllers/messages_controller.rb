class MessagesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  skip_before_action :verify_authenticity_token

  def show; end

  def new
    @order = Order.find(params[:order_id].to_i)

    @message = Message.new(order_id: @order.id)
  end

  def create
    @order = Order.find(params[:message][:order_id].to_i)
    @message = Message.new(message_params)
    @message.order_id = @order.id
    return unless @message.save

    sender_id = @message.sender_id
    receiver_id = @message.receiver_id
    message_content = @message.content
    sender_name = User.find(sender_id).first_name

    count = Notification.already_existing(sender_id, receiver_id)

    ActionCable.server.broadcast("notifications_#{receiver_id}", {
                                   count:,
                                   read: false,
                                   message: message_content,
                                   sender_name:,
                                   sender_id:,
                                   receiver_id:,
                                   order_id: @order.id,
                                   timestamp: Time.now.strftime('%B %d, %Y %I:%M %p')
                                 })

    ActionCable.server.broadcast('room_channel_1', {
                                   sender_id:,
                                   receiver_id:,
                                   sender_name:,
                                   message: message_content,
                                   order_id: @order.id,
                                   timestamp: Time.now.strftime('%I:%M %p')
                                 })

    puts @message.errors.full_messages
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :content)
  end
end
