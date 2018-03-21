desc "This task is called by the Heroku scheduler add-on"
task :expired_test => :environment do
  puts "expired test"
  puts "it works."
end

task :toot => :environment do

    #@toots = Mastodon::REST::Timelines.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])

    puts @toots
    client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])
    message = ("test")
    response = client.create_status(message)
end