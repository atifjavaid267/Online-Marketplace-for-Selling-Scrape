# app/services/bid_broadcast_service.rb

class BidBroadcaster
  def self.call(bid)
    ActionCable.server.broadcast('bids_channel',
                                 { ad_id: bid.ad_id,
                                   price: ActionController::Base.helpers.number_to_currency(bid.price, unit: 'Rs',
                                                                                                       format: '%u. %n'),
                                   buyer_name: bid.user.full_name })
  end
end
