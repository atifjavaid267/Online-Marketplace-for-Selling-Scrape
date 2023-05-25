# frozen_string_literal: true

# Notification Controller
class NotificationsController < ApplicationController
  load_and_authorize_resource

  def create
    if @notification.save
    else
    flash[:error] = @notification.errors.full_messages.join(', ')
    end
  end

  def update
    return unless @notifaction.update(notification_params)
  end

  def destroy
    return unless @notifaction.destroy
  end

  private

  def notification_params
    params.require(:notification).permit(:sender, :receiver, :read)
  end
end
