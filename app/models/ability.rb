# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:show_root], Product

    if user.admin?
      can %i[new create index show edit update destroy publish unpublish archives], Product
      can %i[index show destroy archives view_bids], Ad
      can %i[index show show_pending show_successful show_cancelled cancel], Order

    elsif user.seller?

      can %i[index show], Product
      can %i[new create index edit destroy], Address
      can %i[display_ads new create show edit update destroy publish unpublish archives view_bids],
          Ad
      can :index, Bid
      can %i[index new create show show_pending show_successful show_cancelled confirm cancel], Order
      can %i[index show new create], Message

    elsif user.buyer?

      can %i[index show], Ad
      can %i[new create], Bid
      can %i[index show], Order
      can %i[index show new create], Message
    end
  end
end
