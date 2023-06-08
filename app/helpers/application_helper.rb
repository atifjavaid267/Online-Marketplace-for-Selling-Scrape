module ApplicationHelper
  def status_color(status)
    case status
    when 'pending'
      'text-blue-600'
    when 'successful'
      'text-green-600'
    when 'failed', 'cancelled'
      'text-red-600'
    else
      ''
    end
  end
end
