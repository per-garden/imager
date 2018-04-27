# Presentation

Imager is a rails application fetching graphical images from Google Drive. Images, jpeg/gif/png, are downloaded and normalised to configurable maximum width and height. Normalised copies of the original images are then made globally accessible via differnt image streams. Upon http GET to a stream a randomly pick of one of its images is returned.


## Features

 - Google Drive connectivity
 - Image formatter
 - Image download


# Installation

## Prerequisites

 - Ruby
 - Rubygems
 - Bundle

Server side was tested and verified on Linux 4.4.14 (Slackware 14.2) during March 2018 using:

 - ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-linux]
 - Rubygems 2.4.8
 - Bundler version 1.15.1


## Download

Download from GitHub repository:

 - git clone https://github.com/per-garden/imager.git



# Configuration

## Google Drive

Adapt files config/environments/development.rb and config/environments/production.rb to your needs. The section specifically regarding mail retrieval is shown below:

```
  config.google_drive = {
    # Interval in seconds between checking for drive folder updates
    poll_interval: 60,
    download_directory: 'images'
  }
```

Google credentials are required. First get credential for the account you want to use: https://console.developers.google.com/apis/credentials?project=omnildap&folder&organizationId

Create a credentials file as config/google/credentials.json. Initially let it contain:

```
{
  "client_id": "XXXX",
  "client_secret": "YYYY"
}
```

# Setup

## Gems

Go to directory as created by git clone. Then type:

 - bundle install


## Setting up data

Initiate the database(s):

 - bundle exec rake db:setup

Downloaded images are stored into feeds, providing normalised images to clients. At least one feed is required. Create feed using the Rails console. E.g. `Feed.create(name: 'default', count: 20, geometry: '640x420')`


# Usage

Be positioned in the imager directory.

 - run `rake secret` and create a config/secrets.yml file
 - RAILS_ENV=production rake assets:precompile

On first start Google will prompt for a session token. Start irb (not rails console) and do:

```
ruby@infotv:~/projects/imager$ irb
irb(main):001:0> require "google_drive"
=> true
irb(main):002:0> session = GoogleDrive::Session.from_config("config/google/credentials.json")

1. Open this page:
https://accounts.google.com/o/oauth2/auth?access...

2. Enter the authorization code shown in the page: ZZZZ
=> #<GoogleDrive::Session:0x2ac12aa251f0>
irb(main):003:0>
```

```
{ 
  "client_id": "XXXX",
  "client_secret": "YYYY",
  "scope": [
    "https://www.googleapis.com/auth/drive",
    "https://spreadsheets.google.com/feeds/"
  ],
  "refresh_token": "ZZZZ"
}


Then start rails server:

```html
per@lex14:~/projects/imager$ rails s
I, [2018-04-27T12:16:52.398010 #19412]  INFO -- : Celluloid 0.17.3 is running in BACKPORTED mode. [ http://git.io/vJf3J ]
=> Booting Puma
=> Rails 5.1.6 application starting in development 
=> Run `rails server -h` for more startup options
Puma starting in single mode...
* Version 3.11.4 (ruby 2.3.1-p112), codename: Love Song
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://0.0.0.0:3000
Use Ctrl-C to stop
  Feed Load (1.5ms)  SELECT "feeds".* FROM "feeds"
Sending HTTP get https://www.googleapis.com/drive/v3/files/root?fields=%2A&supportsTeamDrives=true
200
#<HTTP::Message:0x0055c370af1ae8 @http_header=#<HTTP::Message::Headers:0x0055c370af1ac0 @http

...

Success - #<Google::Apis::DriveV3::FileList:0x0055c37064cf88
 @files=[],
 @incomplete_search=false,
 @kind="drive#fileList">

```

Now access the application at e.g. http://my_host.my_domain:3000 (For local testing this will be http://localhost:3000). This will display an overview web page listing available feeds. To download images, use the explicit feed url. E.g. http://localhost:3000/default.

Stopping:

```html
^C- Gracefully stopping, waiting for requests to finish
=== puma shutdown: 2018-03-02 11:47:37 +0100 ===
- Goodbye!
Exiting
/home/per/projects/imager/config/initializers/google_drive_fetcher.rb:5:in `block in <top (required)>': Wait for GoogleDriveFetchJob to finish (RuntimeError)
per@lex14:~/projects/imager$
```

Shutting down reports errors although everything is OK...


# Tests

We use rspec for testing. To run all tests a Google Drive account must be accessible and contain a test directory:

```
bundle exec rspec spec
```


# Known Issues and Future Work

 - Neater shutdown, without reported errors.


# Releases

 - v0.1: Initial release

# Licence

Copyright (c) 2018 Avalon Innovation AB.

GNU General Public License. See separate licence file for details.
