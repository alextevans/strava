require 'rubygems'
require 'mechanize'

abort "Usage: #{$0} <path_to_configuration_file> " if (ARGV.size != 1)
@configuration_file = File.read(ARGV[0]).split
@params = {"username" => @configuration_file[0], "password" => @configuration_file[1], "location"=> @configuration_file[2]}


def download_activities file_name
  agent = Mechanize.new
  uri = URI 'https://connect.garmin.com/signin'
  begin
    page = agent.get uri
    login_form = page.form_with(:name => "login") do |f|
      f.field_with(:name => "login:loginUsernameField").value = "username"
      f.field_with(:name => "login:password").value = "password"
    end.submit

    activities_page = agent.get "http://connect.garmin.com/activities"
    activity = agent.click(activities_page.link_with(:class => "activityNameLink"))
    activity_id = agent.current_page.form_with(:name => nil).action.gsub("http://connect.garmin.com/activity/", "")
    exported_activity = agent.click(activity.link_with(:id =>"actionGpx"))
    puts "saving ../garmin_activity_#{activity_id}.gpx"
    #exported_activity.save! File.new "../garmin_activity_#{activity_id}.gpx", "w"
    sleep 3
    activity = agent.click(activity.link_with(:id => "previousButton"))
    until activity.nil?
    end
  end
end
