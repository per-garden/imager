# Make sure Feed get correctly loaded as toplevel constant
require Rails.root.join('app/models/feed.rb')

class GoogleDriveFetchJob
  include Celluloid

  @@job = GoogleDriveFetchJob.new

  def self.start
    @@job.async.run
  end

  def self.shutdown
    # Block caller while letting job task finish what it is doing
    @@job.stop
    # Synchronously terminate
    @@job.terminate
  end

  # Work task to be run asynchronously
  def run
    @keep_running = true

    session = GoogleDrive::Session.from_config("config/google/credentials.json")
    while @keep_running
      Feed.all.each do |feed|
        download_directory = "#{Rails.application.config.google_drive[:download_directory]}/#{feed.name}"
        directory = session.collection_by_title("#{feed.name}")
        if directory && directory.files 
          directory.files.each do |google_file|
            name = google_file.title
            if (feed.images.to_a.select {|im| im.name == name}).empty?
              unless feed.images.count < feed.count
                image = feed.images.order(created_at: :asc).first
                path = download_directory + '/' + image.name
                File.exists?(path) ? File.delete(path) : nil
                image.destroy
              end
              google_file.download_to_file("#{download_directory}/#{name}")
              image = Image.new(name: google_file.title)
              image.feed = feed
              image.save!
            end
          end
        end
      end
      sleep(Rails.application.config.google_drive[:poll_interval].to_i)
    end
    @running = false
  end

  # Block caller until work task in run method finished
  def stop
    @keep_running = false
    while @running
      #
    end
  end

end
