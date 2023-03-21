# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    user ||= User.new

    if user.admin?
      can :create, Product
      can :index, Product
      can :view, Product
      can :destroy, Product
    end

    if user.seller?
      can :index, Product
      can :view, Product
    end

    can :view, Product
  end
end
