class BidsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'bids_channel'
  end

  def unsubscribed; end
end
