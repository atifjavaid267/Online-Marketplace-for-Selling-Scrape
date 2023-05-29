module BidsHelper
  def bids_status_css(status)
    case status
    when 'pending'
      'text-blue-600'
    when 'successful'
      'text-green-600'
    when 'failed'
      'text-red-600'
    else
      ''
    end
  end
end
