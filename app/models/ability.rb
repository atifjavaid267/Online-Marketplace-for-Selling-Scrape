# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:show_root], Product

    if user.admin?
      can %i[new create show index edit update destroy publish unpublish archives], Product
      can %i[index show destroy archives view_bids], Ad
      can %i[index show show_pending show_successful show_cancelled cancel], Order

      cannot %i[new create], Bid
      cannot %i[index show new create], Message

    elsif user.seller?
      can %i[index], Product
      can %i[show], Product, status: true

      can %i[new create index edit destroy], Address
      can %i[display_ads new create edit update destroy publish unpublish archives view_bids], Ad
      can %i[show], Ad, user_id: user.id

      can %i[index], Bid
      can %i[index new create show_pending show_successful show_cancelled confirm cancel], Order
      can %i[show], Order, bid: { ad: { user_id: user.id } }
      can %i[index show new create], Message

      cannot %i[new create], Bid

    elsif user.buyer?
      can %i[index], Ad
      can %i[show], Ad, status: true
      can %i[new create index], Bid
      can %i[index show], Order, bid: { user_id: user.id }
      can %i[index show new create], Message

      cannot %i[new create show edit update destroy publish unpublish archives], Product
      cannot %i[display_ads new create edit update destroy publish unpublish archves view_bids], Ad
      cannot %i[new create index edit destroy], Address
      cannot %i[show_pending show_successful show_cancelled cancel], Order

    end
  end
end
