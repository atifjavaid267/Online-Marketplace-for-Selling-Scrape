# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    user ||= User.new

    can [:show_root], Product

    # cannot [:index], Product

    ####### ADMIN ########

    if user.admin?
      can [:new, :create, :index, :show, :edit, :update, :destroy, :publish, :unpublish, :archives], Product

      can [:index, :show, :destroy, :archives, :view_bids], Ad
      can [:index, :show, :show_pending, :show_successful, :show_cancelled, :cancel], Order



    ####### SELLER ########

    elsif user.seller?


      can [:index, :show], Product

      can [:new, :create, :index, :edit], Address

      can [:display_ads, :new, :create, :show, :edit, :update, :destroy, :publish, :unpublish, :archives, :view_bids], Ad

      can :index, Bid

      can [:index, :new, :create, :show, :show_pending, :show_successful, :show_cancelled, :confirm, :cancel], Order

      can [:index, :show, :new, :create], Message


    ####### BUYER ########

    elsif user.buyer?

      can [:index, :show], Ad
      can [:new, :create], Bid
      can [:index, :show], Order

      can [:inde, :show, :new, :create], Message

    end
  end
end
