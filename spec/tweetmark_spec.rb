require File.dirname(__FILE__) + '/spec_helper'
require 'tweetmark'

describe "Maruku with Tweetmark enabled" do
  before(:each) do
    Tweetmark.enable
  end
  
  it "should interpret twitter blocks" do
    markdown = <<-MARKDOWN
+twitter
does that cause global variable warming? (har har har)
=twitter
    MARKDOWN
    
    Maruku.new(markdown).to_html.should have_selector(".tweet") { |tweet|
      tweet.should have_selector(".tweet-body") { |body|
        body.inner_html.strip.should == 'does that cause global variable warming? (har har har)'
      }
    }
  end
  
  it "should linkify usernames" do
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

  it "should add profile info" do
    markdown = <<-MARKDOWN
+twitter
@peeja does that cause global variable warming? (har har har)
 @gooberdlx (Jake Good) [http://s3.amazonaws.com/twitter_production/profile_images/74240660/Photo_7b_normal.jpg]
=twitter
    MARKDOWN
    
    Maruku.new(markdown).to_html.should have_selector(".tweet") { |tweet|
      tweet.should have_selector(".tweet-profile") { |profile|
        profile.inner_html.should =~ %r|<img class="tweet-avatar" src="http://s3.amazonaws.com/twitter_production/profile_images/74240660/Photo_7b_normal.jpg" alt="">|
        profile.inner_html.should =~ %r|<a href="http://twitter.com/gooberdlx" class="tweet-username">gooberdlx</a>|
        profile.inner_html.should =~ %r|<div class="tweet-realname">Jake Good</div>|
      }
    }
  end
  
  it "should add a permalink with the date" do
    markdown = <<-MARKDOWN
+twitter:1184488422
@peeja does that cause global variable warming? (har har har)
 at Fri Feb 06 21:05:44 +0000 2009
 @gooberdlx (Jake Good) [http://s3.amazonaws.com/twitter_production/profile_images/74240660/Photo_7b_normal.jpg]
=twitter
    MARKDOWN
    
    Maruku.new(markdown).to_html.should have_selector(".tweet") { |tweet|
      tweet.should have_selector(".tweet-meta") { |meta|
        meta.inner_html.should =~ %r|<a href="http://twitter.com/gooberdlx/statuses/1184488422" class="tweet-permalink">4:05 PM Feb 6th, 2009</a>|
      }
    }
  end
  
  it "should add source information" do
    markdown = <<-MARKDOWN
+twitter
@peeja does that cause global variable warming? (har har har)
 from web
=twitter
    MARKDOWN
    
    Maruku.new(markdown).to_html.should have_selector(".tweet") { |tweet|
      tweet.should have_selector(".tweet-meta") { |meta|
        meta.inner_html.should =~ %r|from web|
      }
    }
  end

  it "should add linked source information" do
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
end
