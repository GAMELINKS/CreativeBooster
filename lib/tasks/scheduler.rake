desc "This task is called by the Heroku scheduler add-on"
task :expired_test => :environment do
  puts "expired test"
  puts "it works."
end

task :toot => :environment do

    client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])
    @keywords = Keyword.all

    #指定のハッシュタグを含むTootのBoost
    @keywords.each do |keyword|

      client.hashtag_timeline(keyword.key, :limit => 5000).each do |toot|
        if !toot.reblogged? then
          response = client.reblog(toot.id)
          response = client.favourite(toot.id)
        end
      end
    end
end

task :followed_and_mention => :environment do
  client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])

  user = client.followers(1).first
  creatodon = client.account(11343) 

  if user.url =~ /gamelinks007.net/ && !(client.follow(user.id).following?) then
    message = ("@#{user.acct}さん！\n
                Creatodonへようこそ！\n\n
                このインスタンスは創作物全般(絵、小説、ゲームなどなど)を話すインスタンスです。\n
                一次、二次の区別なく創作に関する話をできたらと思っています\n\n    
                お互いの活動内容なども共有できたらいいなと思います。\n
                普通にTwitter 代わりとして利用していただいても構いません\n")

    response = client.create_status(message)
    response = client.follow_by_uri(user.acct)
  end
end

task :follow => :environment do
  client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])

  @keywords = Keyword.all

  @keywords.each do |keyword|
    
    client.hashtag_timeline(keyword.key, :limit => 500).each do |toot|
      url = toot.account.acct
      response = client.follow_by_uri(url)
    end
  end
end

task :unfollow => :environment do
  client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])

  @keywords = Keyword.all

  @keywords.each do |keyword|
    
    client.hashtag_timeline(keyword.key, :limit => 5).each do |toot|
      id = toot.account.id
      response = client.unfollow(id)
    end
  end
end
