class Image < ApplicationRecord
  belongs_to :feed
  validates :geometry, format: { with: /\0[0-9]+\9x\0[0-9]+\9/ }
end
