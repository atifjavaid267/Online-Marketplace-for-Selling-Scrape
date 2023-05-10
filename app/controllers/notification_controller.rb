class NotificationController < ApplicationController
  def index
    @notifications = Notification.all
  end

  def show
    @notifications = Notification.find(params[:id])
  end

  def create
    @notification = Notifications.new(notification_params)
    @notification.save
  end

  def update
    @notification = Notification.find(params[:id])
    @notifaction.update(notification_params)
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notifaction.destroy
  end

  private

  def notification_params
    params.require(:notification).permit(:sender, :receiver, :read)
  end
end
