class MessagesController < ApplicationController
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  skip_before_action :verify_authenticity_token
  def show; end

  def new
    @order = Order.find(params[:order_id])
  end

  def create
    @message = Message.new(message_params)

    return unless @message.save

    sender_id = @message.sender_id
    receiver_id = @message.receiver_id
    message_content = @message.content
    # create or update notification
    notification = Notification.already_existing(sender_id, receiver_id)
    if notification.nil?
      notification = Notification.create(sender_id:, receiver_id:)
    else
      notification_count = notification.count
      notification.update(count: notification_count + 1)
    end

    # broadcast notification
    ActionCable.server.broadcast("notifications_#{receiver_id}", {
                                   count: notification.count,
                                   read: false,
                                   message: message_content,
                                   sender_id:,
                                   receiver_id:,
                                   timestamp: Time.now.strftime('%B %d, %Y %I:%M %p')
                                 })

    # broadcast message
    ActionCable.server.broadcast('room_channel_1', {
                                   sender_id:,
                                   receiver_id:,
                                   message: message_content,
                                   timestamp: Time.now.strftime('%B %d, %Y %I:%M %p')
                                 })

    puts @message.errors.full_messages
  end

  # def create
  #   @message = Message.new(message_params)

  #   return unless @message.save

  #   sender_id = @message.sender_id
  #   receiver_id = @message.receiver_id
  #   message_content = @message.content

  #   notification = Notification.already_existing(sender_id, receiver_id)
  #   if notification.nil?
  #     notification = Notification.create(sender_id:, receiver_id:)
  #   else
  #     notification_count = notification.count
  #     notification.update(count: notification_count + 1)
  #   end

  #   time = Time.now.strftime('%B %d, %Y %I:%M %p')

  #   ActionCable.server.broadcast('room_channel_1', {
  #                                  sender_id:,
  #                                  receiver_id:,
  #                                  message: message_content,
  #                                  timestamp: time
  #                                })

  #   puts @message.errors.full_messages
  # end

  # def create
  #   @message = Message.new(message_params)

  #   return unless @message.save

  #   sender = @message.sender_id
  #   receiver = @message.receiver_id
  #   message_content = @message.content

  #   notification = Notification.already_existing(sender_id, receiver)
  #   if notification.nil?
  #     notification = Notification.create(sender: sender.to_s, receiver: receiver.to_s)
  #   else
  #     notification_count = notification.count
  #     notification.update(count: notification_count + 1)
  #   end

  #   ActionCable.server.broadcast("notification_channel_#{receiver}",
  #                                notification: notification.count)

  #   time = Time.now.strftime('%B %d, %Y %I:%M %p')

  #   ActionCable.server.broadcast('room_channel_1', {
  #                                  sender_id: sender,
  #                                  receiver_id: receiver,
  #                                  message: message_content,
  #                                  timestamp: time
  #                                })

  #   puts @message.errors.full_messages
  # end

  private

  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :content)
  end
end
