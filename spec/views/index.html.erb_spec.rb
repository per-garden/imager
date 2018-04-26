require 'spec_helper'

describe 'feeds/index.html.erb', type: :view do
  context "with 1 feed" do
    before(:each) do
      # Must be named exactly @feeds as in view rendered!
      @feeds = [create(:feed)]
    end

    it 'renders list of feeds' do
      render
      expect(rendered).to include(@feeds[0].name)
      expect(rendered).to include(@feeds[0].upload_url)
      expect(rendered).to include(@feeds[0].count.to_s)
      expect(rendered).to include(@feeds[0].geometry)
    end

    after(:each) do
      Feed.destroy_all
    end
  end
end
