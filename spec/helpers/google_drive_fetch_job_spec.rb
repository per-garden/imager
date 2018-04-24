require 'spec_helper'
require 'helpers/google_drive_spec_helper'

include GoogleDriveSpecHelper

describe GoogleDriveFetchJob, :type => :helper do

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

  it 'fetches any image if no restrictions' do
    sleep(Rails.application.config.google_drive[:poll_interval].to_i * 2)
    expect(Image.count).to eq 1
    expect(Dir.entries(@download_directory)).to include @image
  end

  after(:each) do
    @directory.files.each do |f|
      # Delete is not delete unless "permanent"!!
      f.delete(permanent = true)
    end
    path = "#{@download_directory}/#{@image}"
    remove_dir(path)
  end

  after(:all) do
    # Cleanup and delete feed
    @directory.files.each do |f|
      f.delete(permanent = true)
    end
    @feed.destroy
    Dir["#{@download_directory}/*"].each do |f|
      remove_dir(f)
    end
  end
end
