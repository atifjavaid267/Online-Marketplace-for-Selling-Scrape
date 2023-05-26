class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:show_root], Product

    if user.admin?
      can %i[new create show index edit update destroy toggle_status], Product
      can %i[index show destroy view_bids toggle_status], Ad
      can %i[index show], Order

    elsif user.seller?

      can %i[index show], Product, status: true

      can %i[new create], Address
      can %i[index edit update destroy], Address, user_id: user.id

      can %i[new create toggle_status view_bids], Ad
      can %i[index show edit update destroy], Ad, user_id: user.id

      can %i[new create confirm cancel], Order
      can %i[index show], Order, bid: { ad: { user_id: user.id } }

      can %i[show new create], Message

    elsif user.buyer?

      can %i[index show], Product, status: true

      can %i[index show], Ad, status: true

      can %i[new create], Bid
      can %i[index], Bid, user_id: user.id

      can %i[index show], Order, bid: { user_id: user.id }
      can %i[show new create], Message
    end
  end
end
