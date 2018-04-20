module GoogleDriveSpecHelper

  # Synchronous!! and no additional lib directory deletion
  # Creds to: https://stackoverflow.com/users/771740/jonatasteixeira
  def remove_dir(path)
    if File.directory?(path)
      Dir.foreach(path) do |file|
        if ((file.to_s != ".") and (file.to_s != ".."))
          remove_dir("#{path}/#{file}")
        end
      end
      Dir.exists?(path) ? Dir.delete(path) : nil
    else
      File.exists?(path) ? File.delete(path) : nil
    end
  end

end
