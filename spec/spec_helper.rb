require 'rubygems'
require 'spec'
require 'webrat'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../vendor/sequel')
require 'sequel'

Sequel.sqlite

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'post'
require 'tweetmark'
require 'tweet'

require 'ostruct'
Blog = OpenStruct.new(
	:title => 'My blog',
	:author => 'Anonymous Coward'
) unless defined? Blog


class Object
  def each_should(*args)
    each {|item| item.should(*args)}
  end
  
  def each_should_not(*args)
    each {|item| item.should_not(*args)}
  end
end

Spec::Runner.configure do |config|
  config.include Webrat::Matchers
  config.include Webrat::HaveTagMatcher
end
