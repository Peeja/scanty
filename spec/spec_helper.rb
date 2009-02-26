$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../vendor/andand-1.3.1/lib'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../vendor/rack-openid'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../vendor/ruby-openid-2.1.2/lib'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../vendor/sequel'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../vendor/httparty-0.3.1/lib'

require 'rubygems'
require 'spec'
require 'webrat'
require 'sequel'

Sequel.sqlite

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
