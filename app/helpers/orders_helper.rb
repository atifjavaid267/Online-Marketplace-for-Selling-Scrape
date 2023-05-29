module OrdersHelper
  def order_status_css(status)
    case status
    when 'pending'
      'text-blue-600'
    when 'successful'
      'text-green-600'
    when 'cancelled'
      'text-red-600'
    else
      ''
    end
  end
end
