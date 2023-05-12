# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:show_root], Product

    if user.admin?
      can %i[new create show index edit update destroy toggle_published archives], Product
      can %i[index show destroy archives view_bids toggle_published], Ad
      can %i[index show show_pending show_successful show_cancelled], Order

    elsif user.seller?

      can %i[index], Product
      can %i[show], Product, status: true

      can %i[index], Address, user_id: user.id
      can %i[new create], Address
      can %i[edit update destroy], Address, user_id: user.id

      can %i[new create toggle_published view_bids], Ad
      can %i[index archives show edit update destroy], Ad, user_id: user.id

      can %i[index], Bid

      can %i[new create confirm cancel], Order
      can %i[index show show_pending show_successful show_cancelled], Order, bid: { ad: { user_id: user.id } }

      can %i[show new create], Message

    elsif user.buyer?
      can %i[index], Ad
      can %i[show], Ad, status: true

      can %i[new create], Bid
      can %i[index], Bid, user_id: user.id

      can %i[index show], Order, bid: { user_id: user.id }
      can %i[show new create], Message

    end
  end
end
