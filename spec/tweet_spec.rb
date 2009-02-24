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
    before do
      tweet = Tweet.new do |t|
        t.id                      = 1227845299
        t.text                    = "@ChrisRicca I'm afraid it has."
        t.user_screen_name        = "peeja"
        t.user_name               = "Peter Jaros"
        t.user_profile_image_url  = "http://s3.amazonaws.com/twitter_production/profile_images/78948024/blacked-out_normal.jpg"
        t.created_at              = Time.parse("Thu Feb 19 19:47:14 +0000 2009")
        t.source                  = "<a href=\"http://iconfactory.com/software/twitterrific\">twitterrific</a>"
        t.in_reply_to_screen_name = "ChrisRicca"
        t.in_reply_to_status_id   = 1227585280
      end
      
      @tweetmark_lines = tweet.to_tweetmark.split("\n")
    end
    
    it("opens the Tweetmark block with the id of the Tweet") { @tweetmark_lines.first.should == "+twitter:1227845299" }
    it("includes the body of the Tweet")                     { @tweetmark_lines.should  include("@ChrisRicca I'm afraid it has.") }
    it("includes the author's profile information")          { @tweetmark_lines.should  include("  @peeja (Peter Jaros) [http://s3.amazonaws.com/twitter_production/profile_images/78948024/blacked-out_normal.jpg]") }
    it("includes the date of the Tweet")                     { @tweetmark_lines.should  include("  at Thu Feb 19 19:47:14 UTC 2009") }
    it("includes the source of the Tweet")                   { @tweetmark_lines.should  include("  from <a href=\"http://iconfactory.com/software/twitterrific\">twitterrific</a>") }
    it("includes a reference to the tweet replied to")       { @tweetmark_lines.should  include("  in reply to ChrisRicca:1227585280") }
    it("closes the Tweetmark block")                         { @tweetmark_lines.last.should  == "=twitter" }
  end
end
