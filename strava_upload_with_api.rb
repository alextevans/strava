require 'rubygems'
require 'mechanize'

abort "Usage: #{$0} <path_to_configuration_file>" if (ARGV.size != 1)
@configuration_file = File.read(ARGV[0]).split
abort "config file needs 6 items" if @configuration_file.size != 6
@params = {"email" => @configuration_file[0], "password" => @configuration_file[1],
           "data_path"=> @configuration_file[2], "access_token"=> @configuration_file[3],
           "secret"=> @configuration_file[4], "client_id"=>@configuration_file[5]}
#puts @params.inspect

@p=[]

if Dir.exists?@params["data_path"]
  @data = Dir.entries(@params["data_path"])
  @path = @params["data_path"]
  @access_token = @params["access_token"]
  @secret = @params["secret"]
  @client_id = @params["client_id"]
else puts "path to data is invalid"
end

def upload_using_api files
  oauth_access_token = get_oauth_access_token
  command =  "curl -X POST https://www.strava.com/api/v3/uploads \
    -F access_token=#{oauth_access_token} \
    -F file=% \
    -F data_type=gpx"
  files.each do |i|
    c = command.gsub(/%/, i)
    puts "\n\n" + c
    system(c)
    sleep 2
  end
end

def get_oauth_access_token
  agent = Mechanize.new
  uri = URI 'https://www.strava.com/login'
  begin
    page = agent.get uri
    #puts page.inspect
    my_page = page.form_with(:id => 'login_form') do |form|
      form.email = "alextevans@gmail.com"
      form.password = "Theostr0"
    end.submit
  end

  auth_request="https://www.strava.com/oauth/authorize?client_id=#{@client_id}&response_type=code&redirect_uri=http://localhost&scope=write&state=mystate&approval_prompt=force"

  uri = URI auth_request
  agent.get uri
  authorize = agent.page.forms[0].submit
  auth_code =  authorize.uri.to_s.split("&")[1].gsub("code=", "")
  access_token_request = "https://www.strava.com/oauth/token?client_id=#{@client_id}&client_secret=121282b20a2902b1a28b9472d5bef47a3bc1fa94&code=#{auth_code}"
  uri = URI access_token_request
  oauth_access_token = agent.post(uri).body.split(":")[1].gsub(/\W/, "")
  return oauth_access_token

end


@data.each do |file|
  #check if the file ends with gpx
  if file =~ %r{.*\.gpx}
    @p << @path + file
  end
end

upload_using_api @p

