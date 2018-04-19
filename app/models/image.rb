class Image < ApplicationRecord
  belongs_to :feed
  validates :geometry, format: { with: /[1-9][0-9]*x[1-9][0-9]/ }
end
