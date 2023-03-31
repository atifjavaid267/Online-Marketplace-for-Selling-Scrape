# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    # user ||= User.new

    if user.admin?
      can :create, Product
      can :index, Product
      can :show, Product
      can :destroy, Product

      can :index, Ad
      can :show, Ad
      can :destroy, Ad

    end

    if user.seller?
      can :index, Product
      can :show, Product

      can :create, Address
      can :index, Address
      can :edit, Address

      can :display_ads, Ad
      can :show, Ad
      can :edit, Ad
      can :destroy, Ad

      can :index, Bid

    end

    if user.buyer?
      can :index, Ad
      can :show, Ad

      can :create, Bid
    end
  end
end
