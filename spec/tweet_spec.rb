require File.dirname(__FILE__) + '/spec_helper'

describe Tweet do
  describe ".find" do
    it "looks up and instantiates Tweets" do
      Tweet.stub!(:get).with("http://twitter.com/statuses/show/1227845299.json").and_return(
        {"user"=>
          {"name"=>"Peter Jaros",
           "url"=>"http://peeja.com/",
           "id"=>709433,
           "description"=>"I work on awesome things.  One of them is drop.io.",
           "protected"=>false,
           "screen_name"=>"peeja",
           "followers_count"=>206,
           "location"=>"Brooklyn, NY",
           "profile_image_url"=>
            "http://s3.amazonaws.com/twitter_production/profile_images/78948024/blacked-out_normal.jpg"},
         "truncated"=>false,
         "favorited"=>false,
         "text"=>"@ChrisRicca I'm afraid it has.",
         "id"=>1227845299,
         "in_reply_to_status_id"=>1227585280,
         "in_reply_to_user_id"=>5815462,
         "source"=>
          "<a href=\"http://iconfactory.com/software/twitterrific\">twitterrific</a>",
         "in_reply_to_screen_name"=>"ChrisRicca",
         "created_at"=>"Thu Feb 19 19:47:14 +0000 2009"})
      
      tweet = Tweet.find(1227845299)
      
      tweet.id.should                      == 1227845299
      tweet.text.should                    == "@ChrisRicca I'm afraid it has."
      tweet.user_screen_name.should        == "peeja"
      tweet.user_name.should               == "Peter Jaros"
      tweet.user_profile_image_url.should  == "http://s3.amazonaws.com/twitter_production/profile_images/78948024/blacked-out_normal.jpg"
      tweet.created_at.should              == Time.parse("Thu Feb 19 19:47:14 +0000 2009")
      tweet.source.should                  == "<a href=\"http://iconfactory.com/software/twitterrific\">twitterrific</a>"
      tweet.in_reply_to_screen_name.should == "ChrisRicca"
      tweet.in_reply_to_status_id.should   == 1227585280
    end
  end
  
  describe "#to_tweetmark" do
    it "includes the body of the Tweet"
    it "includes the author's profile information"
    it "includes the date of the Tweet"
    it "includes the source of the Tweet"
    it "includes a reference to the tweet replied to"
  end
end
