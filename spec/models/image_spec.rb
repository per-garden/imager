require 'rails_helper'

RSpec.describe Image, type: :model do

  it "has a valid factory" do
    expect(build :image).to be_valid
    expect(build :bad_image).not_to be_valid
  end

end
