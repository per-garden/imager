class FeedsController < ApplicationController
  def index
    ActionController::Parameters.permit_all_parameters = true
    @feeds = Feed.all
  end

  def show
    name = params[:name]
    download_directory = "#{Rails.application.config.google_drive[:download_directory]}/#{name}"
    fm = FileMagic.new
    f = (Dir.entries(download_directory).reject {|f| f[0] == '.'}).sample(1)[0]
    type = fm.file("#{download_directory}/#{f}")
    if type.include?('JPEG image data')
      send_data(open("#{download_directory}/#{f}") { |f| f.read }, :type => 'image/jpeg')
    elsif type.include?('GIF image data')
      send_data(open("#{download_directory}/#{f}") { |f| f.read }, :type => 'image/gif')
    elsif type.include?('PNG image data')
      send_data(open("#{download_directory}/#{f}") { |f| f.read }, :type => 'image/png')
    else
      nil
    end
  end
end
