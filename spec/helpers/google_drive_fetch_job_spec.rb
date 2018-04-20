require 'spec_helper'
require 'helpers/google_drive_spec_helper'

include GoogleDriveSpecHelper

describe GoogleDriveFetchJob, :type => :helper do
  before(:all) do
    # A clean test download directory is needed
    @download_directory = "#{Rails.root}/#{Rails.application.config.google_drive[:download_directory]}/test"
    Dir.mkdir @download_directory
    # A (test) google account is needed!
    session = GoogleDrive::Session.from_config("config/google/credentials.json")
    # Expect test account's drive to have (empty) folder named pics
    @directory = session.collection_by_title('test')
    @image = 'medium.jpg'
    @file = @directory.upload_from_file("spec/#{@image}")
  end

  before(:each) do
    @feed = create(:test_feed)
  end

  it 'fetches any image if no restrictions' do
    sleep(Rails.application.config.google_drive[:poll_interval].to_i * 2)
    expect(Image.count).to eq 1
    expect(Dir.entries(@download_directory)).to include @image
  end

  after(:each) do
    path = "#{@download_directory}/#{@image}"
    # Give polling thread a chance to finish before deleting its directory
    sleep(Rails.application.config.google_drive[:poll_interval].to_i)
    remove_dir(path)
    @feed.destroy
  end

  after(:all) do
    @directory.remove(@file)
    remove_dir(@download_directory)
  end
end
