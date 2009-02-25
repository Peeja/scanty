require File.dirname(__FILE__) + '/../vendor/maruku/maruku'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../vendor/syntax'
require 'syntax/convertors/html'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../vendor/htmlentities-4.0.0/lib'
require 'htmlentities'

class Post < Sequel::Model
	unless table_exists?
		set_schema do
			primary_key :id
			text :title
			text :body
			text :slug
			text :tags
			timestamp :created_at
		end
		create_table
	end
	
	before_save :lookup_tweets do
	  body.gsub! /^\[twitter:(\d+)\]\r?\n/ do
	    tweet_id = $1.to_i
	    Tweet.find(tweet_id).to_tweetmark
	  end
	end

	def url
		d = created_at
		"/past/#{d.year}/#{d.month}/#{d.day}/#{slug}/"
	end

	def body_html
		to_html(body)
	end

	def summary
		summary, more = split_content(body)
		summary
	end

	def summary_html
		to_html(summary)
	end

	def more?
		summary, more = split_content(body)
		more
	end

	def linked_tags
		tags.split.inject([]) do |accum, tag|
			accum << "<a href=\"/past/tags/#{tag}\">#{tag}</a>"
		end.join(" ")
	end

	def self.make_slug(title)
		title.downcase.gsub(/ /, '_').gsub(/[^a-z0-9_]/, '').squeeze('_')
	end

	########

  def to_html(markdown)
    h = Maruku.new(markdown).to_html
    h.gsub(/<code>([^<]+)<\/code>/m) do
      convertor = Syntax::Convertors::HTML.for_syntax "ruby"
      highlighted = convertor.convert(HTMLEntities.new.decode($1), false)
      "<code>#{highlighted}</code>"
    end
  end

	def split_content(string)
		parts = string.gsub(/\r/, '').split("\n\n")
		show = []
		hide = []
		parts.each do |part|
			if show.join.length < 100
				show << part
			else
				hide << part
			end
		end
		[ to_html(show.join("\n\n")), hide.size > 0 ]
	end
end
