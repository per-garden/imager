require 'spec_helper'
require 'helpers/google_drive_spec_helper'
require 'fileutils'

include GoogleDriveSpecHelper

describe GoogleDriveFetchJob, :type => :helper do

   before(:all) do
     # A clean test download directory is needed
     @download_directory = "#{Rails.root}/#{Rails.application.config.google_drive[:download_directory]}/test"
     # A (test) google account is needed!
     session = GoogleDrive::Session.from_config("config/google/credentials.json")
     # Expect test account's drive to have (empty) folder named test
     @directory = session.collection_by_title('test')
   end

  describe 'fetch without previous images' do

    before(:all) do
      @feed = create(:test_feed)
      @small_image = 'small.jpg'
      FileUtils.cp("spec/#{@small_image}", @download_directory)
      image = Image.new(name: @small_image)
      image.feed = @feed
      image.save!
      @image = 'medium.jpg'
      @directory.upload_from_file("spec/#{@image}")
    end

    it 'fetches image' do
      sleep(Rails.application.config.google_drive[:poll_interval].to_i * 2)
      expect(Dir.entries(@download_directory)).to include @image
    end

    it 'resizes image' do
      sleep(Rails.application.config.google_drive[:poll_interval].to_i * 2)
      actual = FastImage.size("#{@download_directory}/#{@image}")
      expected = @feed.geometry.split('x')
      # Resize will set one max while keeping aspect ratio
      expect(actual[0].to_s == expected[0].to_s || actual[1].to_s == expected[1].to_s).to be true
    end

    it 'deletes image if no corresponding image on remote drive' do
      sleep(Rails.application.config.google_drive[:poll_interval].to_i * 2)
      expect(Dir.entries(@download_directory)).not_to include @small_image
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
      @feed = create(:test_feed)
      @image = 'small.jpg'
      @directory.upload_from_file("spec/#{@image}")
      @image = 'medium.jpg'
      @directory.upload_from_file("spec/#{@image}")
      @image = 'large.jpg'
      @directory.upload_from_file("spec/#{@image}")
    end

    it 'fetches image while keeping local max count' do
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

  describe 'fetching files that are not graphical images' do
    before(:all) do
      @feed = create(:test_feed)
      @image = 'crowd-cheering.mp3'
      @directory.upload_from_file("spec/#{@image}")
    end

    it 'does not store non-graphical image' do
      sleep(Rails.application.config.google_drive[:poll_interval].to_i * 2)
      expect(Image.count).to eq 0
      expect(Dir.entries(@download_directory)).not_to include @image
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
