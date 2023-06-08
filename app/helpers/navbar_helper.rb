module NavbarHelper
  def menu_items
    menu = {}
    menu['Home'] = user_signed_in? ? users_home_path : root_path
    menu['Products'] = products_path
    if user_signed_in?
      menu['Ads'] = ads_path
      menu['Bids'] = bids_path if current_user.buyer?
      menu['Orders'] = orders_path
    end

    menu
  end
end
