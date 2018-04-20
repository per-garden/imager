require 'rails_helper'

RSpec.describe Feed, type: :model do

  it "has a valid factory" do
    expect(build :feed).to be_valid
    expect(build :bad_feed1).not_to be_valid
    expect(build :bad_feed2).not_to be_valid
  end

end
