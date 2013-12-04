require 'rubygems'
require 'mechanize'

abort "Usage: #{$0} <path_to_configuration_file> " if (ARGV.size != 1)
@configuration_file = File.read(ARGV[0]).split
@params = {"email" => @configuration_file[0], "password" => @configuration_file[1], "data_path"=> @configuration_file[2]}

if Dir.exists?@params["data_path"]
  data = Dir.entries(@params["data_path"])
  path = @params["data_path"]
else puts "path to data is invalid"
end

def upload_the_file file_name
  agent = Mechanize.new
  uri = URI 'https://www.strava.com/login'
  begin
    page = agent.get uri
    my_page = page.form_with(:id => 'login_form') do |form|
      form.email  = @params["email"]
      form.password = @params["password"]
    end.submit

    ##go to the upload page
    #upload_page = agent.click(my_page.link_with(:class => /upload alt button/))
    ##go to the basic upload form
    #file_upload_page = agent.click(upload_page.link_with(:text => /Upload files directly from your computer/))
    ## Upload the file
    #file_upload_page.form_with(:method => 'POST') do |upload_form|
    #  upload_form.file_uploads.first.file_name = file_name
    #end.submit
  end
  sleep 1
  puts "finished uploading " + file_name
end

data.each do |file|
  #check if the file ends with gpx
  if file =~ %r{.*\.gpx}
    upload_the_file path + file
  end
end


