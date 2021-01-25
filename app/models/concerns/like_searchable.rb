module LikeSearchable
  extend ActiveSupport::Concern

  included do
    scope :search_by_name, lambda { |key, value|
      where(arel_table[key].matches("%#{value}%"))
    }
  end
end
