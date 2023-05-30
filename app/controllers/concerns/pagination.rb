module Pagination
  extend ActiveSupport::Concern

  def paginate_records(records)
    records.paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
  end
end
