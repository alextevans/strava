
require 'rubygems'
require 'mechanize'

abort "Usage: #{$0} <path_to_configuration_file>" if (ARGV.size != 2)
@configuration_file = File.read(ARGV[0]).split
@params = {"email" => @configuration_file[0], "password" => @configuration_file[1], "data_path"=> @configuration_file[2] "access_token"=> @configuration_file[3]}

@p=[]
access_token = ""

if Dir.exists?@params["data_path"]
  data = Dir.entries(@params["data_path"])
  path = @params["data_path"]
  access_token = @params["access_token"]
else puts "path to data is invalid"
end

def upload_using_api files
  command =  "curl -X POST https://www.strava.com/api/v3/uploads \
    -F access_token=#{access_token}\
    -F file= % \
    -F data_type=gpx"
  files.each do |i|
    c = command.gsub(/%/, i)
    puts "\n\n" + c
    #system(c)
  end
end

data.each do |file|
  #check if the file ends with gpx
  if file =~ %r{.*\.gpx}
    @p << path + file
  end
end

upload_using_api @p

