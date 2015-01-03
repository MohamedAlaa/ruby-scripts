require 'json'
require 'mathn'
require 'dotenv'
require 'twitter'
require 'benchmark'

Dotenv.load

time = Benchmark.realtime do

  # Gem Config: https://github.com/sferik/twitter/blob/master/examples/Configuration.md
  config = {
    consumer_key:        ENV['CONSUMER_KEY'], # Add your keys in the .env file
    consumer_secret:     ENV['CONSUMER_SECRET'],
    access_token:        ENV['ACCESS_TOKEN'],
    access_token_secret: ENV['ACCESS_TOKEN_SECRET']
  }

  client = Twitter::REST::Client.new(config)

  my_username = client.user('mohammedalaa')

  begin
    followers = my_username.followers_count
    friends   = my_username.friends_count

    puts "\n"
    puts "Twitter Efficiency: #{ (followers / friends).round(2) * 100 }%"
    puts "\nefficiency = (followers / friends)*100"

  rescue Twitter::Error::TooManyRequests => error
    # NOTE: Your process could go to sleep for up to 15 minutes but if you
    # retry any sooner, it will almost certainly fail with the same exception.
    sleep error.rate_limit.reset_in + 1
    retry
  end

end

# Benchmark End
puts "\n------------- Benchmark ------------- "
puts "Time elapsed #{time*1000} milliseconds"
puts "------------------------------------- "