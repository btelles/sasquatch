module Detector

  #Adds a method called "#{format}_changes" that does the following:
  #
  #For all files in _@format\_folder_ that have extension _format_, remember their
  #last modified date and compare against their current modified date.
  #Returns an array of file paths for files that changed.
  def add_detector(format)
    old_dates = []
    define_method("#{format}_changes_in") do |folder|
      files = Dir.glob( File.join( folder, "**", "*.#{format}" ) )
      new_dates = files.collect {|f| [ f, File.mtime(f).to_i ] }
      differences = new_dates - old_dates
      old_dates = new_dates
      differences.map {|a| a[0] }
    end
  end

end
