class BidsChannel < ApplicationCable::Channel
  def subscribed
     stream_from "bids_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
