class Feed < ApplicationRecord
  has_many :images, dependent: :destroy
  validates_presence_of :name
  validates_uniqueness_of :name
  # Name sensibly usable as part of URL
  validates :name, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  # A feed must allow at least one image
  validates :count, :numericality => { greater_than_or_equal_to: 1 }
  # Columns x rows
  validates :geometry, format: { with: /[1-9][0-9]*x[1-9][0-9]/ }

  def init
    upload_url = ''
  end
end
