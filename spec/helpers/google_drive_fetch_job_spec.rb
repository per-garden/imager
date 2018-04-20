require 'spec_helper'

describe GoogleDriveFetchJob, :type => :helper do
  before(:all) do
    # A (test) google account is needed!
    session = GoogleDrive::Session.from_config("config/google/test_credentials.json")
    # Expect test account's drive to have (empty) folder named pics
    @directory = session.collection_by_title('test')
    @file = @directory.upload_from_file('spec/medium.jpg')
  end

  before(:each) do
    @feed = create(:feed)
  end

  it 'fetches any image if no restrictions' do
    skip 'Checking that google prerequisites are in place first'
  end

  after(:each) do
    @feed.destroy
    Image.destroy_all
  end

  after(:all) do
    @directory.remove(@file)
  end
end
