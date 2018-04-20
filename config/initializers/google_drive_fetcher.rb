unless File.basename($0) == 'rake'
  GoogleDriveFetchJob.start

  at_exit do
    raise 'Wait for GoogleDriveFetchJob to finish'
    GoogleDriveFetchJob.shutdown
  end
end
