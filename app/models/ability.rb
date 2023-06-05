class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can %i[index show], Product

    if user.admin?
      can %i[new create show index edit update destroy toggle_archived], Product
      can %i[index show destroy view_bids toggle_archived], Ad
      can %i[index show], Order

    elsif user.seller?

      can %i[index show], Product, archived: false

      can %i[new create], Address
      can %i[index edit update destroy], Address, user_id: user.id

      can %i[new create toggle_archived view_bids], Ad
      can %i[index show edit update destroy], Ad, user_id: user.id

      can %i[new create confirm cancel], Order
      can %i[index show], Order, bid: { ad: { user_id: user.id } }

      can %i[show new create], Message

      can %i[show], Bid, ad: { user_id: user.id }

    elsif user.buyer?

      can %i[index show], Product, archived: false

      can %i[index show], Ad, archived: false

      can %i[new create], Bid
      can %i[index], Bid, user_id: user.id

      can %i[index show], Order, bid: { user_id: user.id }
      can %i[show new create], Message
    end
  end
end
