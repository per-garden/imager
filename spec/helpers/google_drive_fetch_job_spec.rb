require 'spec_helper'
require 'helpers/google_drive_spec_helper'
require 'fileutils'

include GoogleDriveSpecHelper

describe GoogleDriveFetchJob, :type => :helper do

  describe 'fetch without previous images' do

    before(:all) do
      # A clean test download directory is needed
      @download_directory = "#{Rails.root}/#{Rails.application.config.google_drive[:download_directory]}/test"
      @feed = create(:test_feed)
      # A (test) google account is needed!
      session = GoogleDrive::Session.from_config("config/google/credentials.json")
      # Expect test account's drive to have (empty) folder named test
      @directory = session.collection_by_title('test')
      @image = 'medium.jpg'
      @directory.upload_from_file("spec/#{@image}")
    end

    it 'fetches image' do
      sleep(Rails.application.config.google_drive[:poll_interval].to_i * 2)
      expect(Image.count).to eq 1
      expect(Dir.entries(@download_directory)).to include @image
    end

    after(:all) do
      @directory.files.each do |f|
        # Delete is not delete unless "permanent"!!
        f.delete(permanent = true)
      end
      @feed.destroy
      Dir["#{@download_directory}/*"].each do |f|
        remove_dir(f)
      end
    end
  end

  describe 'fetch with previous images' do

    before(:all) do
      # A clean test download directory is needed
      @download_directory = "#{Rails.root}/#{Rails.application.config.google_drive[:download_directory]}/test"
      @feed = create(:test_feed)
      @image = 'small.jpg'
      FileUtils.cp("spec/#{@image}", @download_directory)
      image = Image.new(name: @image)
      image.feed = @feed
      image.save!
      @image = 'large.jpg'
      FileUtils.cp("spec/#{@image}", @download_directory)
      image = Image.new(name: @image)
      image.feed = @feed
      image.save!
      # A (test) google account is needed!
      session = GoogleDrive::Session.from_config("config/google/credentials.json")
      # Expect test account's drive to have (empty) folder named test
      @directory = session.collection_by_title('test')
      @image = 'medium.jpg'
      @directory.upload_from_file("spec/#{@image}")
    end

    it 'fetches image' do
      sleep(Rails.application.config.google_drive[:poll_interval].to_i * 2)
      expect(Image.count).to eq 2
      expect(Dir.entries(@download_directory)).to include @image
    end

    after(:all) do
      @directory.files.each do |f|
        # Delete is not delete unless "permanent"!!
        f.delete(permanent = true)
      end
      @feed.destroy
      Dir["#{@download_directory}/*"].each do |f|
        remove_dir(f)
      end
    end

  end
end
