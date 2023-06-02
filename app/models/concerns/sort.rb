module Sort
  extend ActiveSupport::Concern
  included do
    scope :recently_updated, -> { order(updated_at: :desc) }
  end
end
