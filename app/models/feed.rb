class Feed < ApplicationRecord
  # A feed must allow at least one image
  validates :count, :numericality => { greater_than_or_equal_to: 1 }
end
