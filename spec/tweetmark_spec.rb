require File.dirname(__FILE__) + '/spec_helper'
require 'tweetmark'

describe "Maruku with Tweetmark enabled" do
  before(:each) do
    Tweetmark.enable
  end
  
  it "should interpret twitter blocks" do
    pending
    markdown = <<-MARKDOWN
+twitter
does that cause global variable warming? (har har har)
=twitter
    MARKDOWN
    
    p Maruku.new(markdown).to_html
    Maruku.new(markdown).to_html.should have_selector(".tweet") { |tweet|
      tweet.should have_selector(".tweet-body") { |body|
        body.inner_html.strip.should == 'does that cause global variable warming? (har har har)'
      }
    }
  end
  
  it "should linkify usernames" do
    pending
    markdown = <<-MARKDOWN
+twitter
@peeja does that cause global variable warming? (har har har)
=twitter
    MARKDOWN
    
    Maruku.new(markdown).to_html.should have_selector(".tweet") { |tweet|
      tweet.should have_selector(".tweet-body") { |body|
        body.inner_html.strip.should == '@<a href="http://twitter.com/peeja" class="tweet-name">peeja</a> does that cause global variable warming? (har har har)'
      }
    }
  end
  
  it "should add a permalink with the date" do
    pending
    markdown = <<-MARKDOWN
+twitter:1184488422
@peeja does that cause global variable warming? (har har har)
 at Fri Feb 06 21:05:44 +0000 2009
=twitter
    MARKDOWN
    
    Maruku.new(markdown).to_html.should have_selector(".tweet") { |tweet|
      tweet.should have_selector(".tweet-meta") { |meta|
        meta.inner_html.should =~ %r|<a href="http://twitter.com/gooberdlx/statuses/1184488422" class="tweet-permalink">1:05 PM Feb 6th, 2009</a>|
      }
    }
  end
  
  it "should add source information" do
    pending
    markdown = <<-MARKDOWN
+twitter
@peeja does that cause global variable warming? (har har har)
 from <a href="http://iconfactory.com/software/twitterrific">twitterrific</a>
=twitter
    MARKDOWN
    
    Maruku.new(markdown).to_html.should have_selector(".tweet") { |tweet|
      tweet.should have_selector(".tweet-meta") { |meta|
        meta.inner_html.should =~ %r|from <a href="http://iconfactory.com/software/twitterrific">twitterrific</a>|
      }
    }
  end

  it "should add an 'in reply to' link" do
    pending
    markdown = <<-MARKDOWN
+twitter
@peeja does that cause global variable warming? (har har har)
 in reply to peeja:1184481088
=twitter
    MARKDOWN
    
    Maruku.new(markdown).to_html.should have_selector(".tweet") { |tweet|
      tweet.should have_selector(".tweet-meta") { |meta|
        meta.inner_html.should =~ %r|<a href="http://twitter.com/peeja/statuses/1184481088">in reply to peeja</a>|
      }
    }
  end

  it "should add profile info" do
    pending
    markdown = <<-MARKDOWN
+twitter
@peeja does that cause global variable warming? (har har har)
 @gooberdlx (Jake Good) [http://s3.amazonaws.com/twitter_production/profile_images/74240660/Photo_7b_normal.jpg]
=twitter
    MARKDOWN
    
    Maruku.new(markdown).to_html.should have_selector(".tweet") { |tweet|
      tweet.should have_selector(".tweet-profile") { |profile|
        profile.inner_html.should =~ %r|<img src="http://s3.amazonaws.com/twitter_production/profile_images/74240660/Photo_7b_normal.jpg" class="tweet-avatar">|
        profile.inner_html.should =~ %r|<a href="http://twitter.com/gooberdlx" class="tweet-username">gooberdlx</a>|
        profile.inner_html.should =~ %r|<span class="tweet-realname">Jake Good</span>|
      }
    }
  end
end
