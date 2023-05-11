# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:show_root], Product

    if user.admin?
      can %i[new create show index edit update destroy publish unpublish archives], Product
      can %i[show destroy archives view_bids publish unpublish], Ad
      can %i[index], Ad
      can %i[index show show_pending show_successful show_cancelled], Order

    elsif user.seller?
      can %i[index], Product

      can %i[show], Product, status: true

      can %i[new create index edit update destroy], Address

      can %i[new create publish unpublish view_bids], Ad
      can :archives, Ad, user_id: user.id

      can %i[edit update], Ad, user_id: user.id
      can %i[destroy], Ad, user_id: user.id

      can %i[index], Ad, user_id: user.id

      can %i[show], Ad, user_id: user.id

      can %i[index], Bid
      can %i[index new create show_pending show_successful show_cancelled confirm cancel], Order
      can %i[show], Order, bid: { ad: { user_id: user.id } }
      can %i[show new create], Message

    elsif user.buyer?
      can %i[index], Ad
      can %i[show], Ad, status: true
      can %i[new create index], Bid
      can %i[index show], Order, bid: { user_id: user.id }
      can %i[show new create], Message

    end
  end
end
