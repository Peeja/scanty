require File.dirname(__FILE__) + '/spec_helper'

describe Post do
	before do
		@post = Post.new
	end

	it "has a url in simplelog format: /past/2008/10/17/my_post/" do
		@post.created_at = '2008-10-22'
		@post.slug = "my_post"
		@post.url.should == '/past/2008/10/22/my_post/'
	end

	it "produces html from the markdown body" do
		@post.body = "* Bullet"
		@post.body_html.should == "<ul>\n<li>Bullet</li>\n</ul>"
	end
	
	it "expands tweets" do
	  Tweet.stub!(:find).with(1234567).and_return(mock(Tweet, :to_tweetmark => "+twitter\ntwitter-block\n=twitter\n"))
	  
	  @post.body = "foo\n[tweet:1234567]\nbar"
	  @post.save
		@post.body.should == "foo\n+twitter\ntwitter-block\n=twitter\nbar"
	end

	it "syntax highlights code blocks" do
		@post.to_html("<code>\none\ntwo</code>").should == "<code>\n<span class=\"ident\">one</span>\n<span class=\"ident\">two</span></code>"
	end

	it "makes the tags into links to the tag search" do
		@post.tags = "one two"
		@post.linked_tags.should == '<a href="/past/tags/one">one</a> <a href="/past/tags/two">two</a>'
	end

	it "can save itself (primary key is set up)" do
		@post.title = 'hello'
		@post.body = 'world'
		@post.save
		Post.filter(:title => 'hello').first.body.should == 'world'
	end

	it "generates a slug from the title (but saved to db on first pass so that url never changes)" do
		Post.make_slug("RestClient 0.8").should == 'restclient_08'
		Post.make_slug("Rushmate, rush + TextMate").should == 'rushmate_rush_textmate'
		Post.make_slug("Object-Oriented File Manipulation").should == 'objectoriented_file_manipulation'
	end
end
