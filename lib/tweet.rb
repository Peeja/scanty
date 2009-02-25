require 'httparty'

class Tweet
  include HTTParty
  
  class << self
    def new
      t = super
      yield t
      t
    end

    def find(id)
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
  
  def to_tweetmark
    if in_reply_to_screen_name
      in_reply_to  = "  in reply to #{in_reply_to_screen_name}"
      in_reply_to += ":#{in_reply_to_status_id}" if in_reply_to_status_id
      in_reply_to += "\n"
    end
    
    <<-TWEETMARK
+twitter:#{id}
#{text}
  @#{user_screen_name} (#{user_name}) [#{user_profile_image_url}]
  at #{created_at.utc}
  from #{source}
#{in_reply_to}=twitter
TWEETMARK
  end
end
