require 'httparty'

class Tweet
  include HTTParty
  
  def self.new
    t = super
    yield t
    t
  end
  
  def self.find(id)
    t = get("http://twitter.com/statuses/show/#{id}.json")
    
    new do |tweet|
      tweet.id                      = t["id"]
      tweet.text                    = t["text"]
      tweet.user_screen_name        = t["user"]["screen_name"]
      tweet.user_name               = t["user"]["name"]
      tweet.user_profile_image_url  = t["user"]["profile_image_url"]
      tweet.created_at              = Time.parse t["created_at"]
      tweet.source                  = t["source"]
      tweet.in_reply_to_screen_name = t["in_reply_to_screen_name"]
      tweet.in_reply_to_status_id   = t["in_reply_to_status_id"]
    end
  end
  
  attr_accessor :id,
                :text,
                :user_screen_name,
                :user_name,
                :user_profile_image_url,
                :created_at,
                :source,
                :in_reply_to_screen_name,
                :in_reply_to_status_id
end
