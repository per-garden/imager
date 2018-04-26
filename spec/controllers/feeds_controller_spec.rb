require 'rails_helper'
require 'helpers/google_drive_spec_helper'
require 'fileutils'

include GoogleDriveSpecHelper

RSpec.describe FeedsController, type: :controller do

  before(:all) do
    @download_directory = "#{Rails.root}/#{Rails.application.config.google_drive[:download_directory]}/test"
  end

  it 'routes to list of feeds index' do
    expect(get: root_url).to route_to(controller: 'feeds', action: 'index')
  end

  describe 'JPEG download' do
    before(:all) do
      @feed = create(:test_feed)
      @image = 'medium.jpg'
      FileUtils.cp("spec/#{@image}", @download_directory)
      image = Image.new(name: @image)
      image.feed = @feed
      image.save!
    end

    it 'downloads image' do
      get :show, params: {name: 'test'}
      expect(response.headers["Content-Type"]).to eq "image/jpeg"
    end

    after(:all) do
      @feed.destroy
      Dir["#{@download_directory}/*"].each do |f|
        remove_dir(f)
      end
    end
  end

  describe 'GIF download' do
    before(:all) do
      @feed = create(:test_feed)
      @image = 'medium.gif'
      FileUtils.cp("spec/#{@image}", @download_directory)
      image = Image.new(name: @image)
      image.feed = @feed
      image.save!
    end

    it 'downloads image' do
      get :show, params: {name: 'test'}
      expect(response.headers["Content-Type"]).to eq "image/gif"
    end

    after(:all) do
      @feed.destroy
      Dir["#{@download_directory}/*"].each do |f|
        remove_dir(f)
      end
    end
  end

  describe 'PNG download' do
    before(:all) do
      @feed = create(:test_feed)
      @image = 'medium.png'
      FileUtils.cp("spec/#{@image}", @download_directory)
      image = Image.new(name: @image)
      image.feed = @feed
      image.save!
    end

    it 'downloads image' do
      get :show, params: {name: 'test'}
      expect(response.headers["Content-Type"]).to eq "image/png"
    end

    after(:all) do
      @feed.destroy
      Dir["#{@download_directory}/*"].each do |f|
        remove_dir(f)
      end
    end
  end

end
