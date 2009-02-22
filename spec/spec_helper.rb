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

Spec::Runner.configure do |config|
  config.include Webrat::Matchers
  config.include Webrat::HaveTagMatcher
end
