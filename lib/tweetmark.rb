module Tweetmark
  Open  = /^\+twitter(?::(\d+))?/
  Close = /^\=twitter/
  
  class << self
    def enable
      MaRuKu::In::Markdown::register_block_extension(
        :regexp  => Open,
        :handler => lambda do |doc, src, context|
          open_line = src.shift_line
          status_id = Open.match(open_line)[1]
        
          raw_body = ""
          while src.cur_line && !(src.cur_line =~ Close)
            case line = src.shift_line
            when /^  @(\w+) \((.*)\) \[(.*)\]/
              from, from_real, avatar = $1, $2, $3
            when /^  at (.*)$/
              timestamp = Time.parse($1)
            when /^  from <a href="(.*)">(.*)<\/a>$/
              source_url, source = $1, $2
            when /^  from (.*)$/
              source = $1
            when /^  in reply to (.*):(\d+)$/
              reply_to_name, reply_to_id = $1, $2
            else
              raw_body << line
            end
          end
          src.shift_line
          
          tweet_body = []

          # Linkify Twitter usernames
          body = raw_body.split(/\b/).inject([]) do |b, word|
            if b.last.is_a? String and b.last =~ /@$/
              b << doc.md_im_link([word], "http://twitter.com/#{word}", nil, al(:class => "tweet-name"))
            else
              b << word
            end
          end

          tweet_body << doc.md_div(body, al(:class => "tweet-body"))
          
          tweet_meta = []
          
          if timestamp and from and status_id
            ordinal = { 1 => 'st', 2 => 'nd', 3 => 'rd' }[timestamp.day] || 'th'
            timestamp_text = timestamp.strftime "%l:%M %p %b %e#{ordinal}, %Y"
            permalink = doc.md_im_link([timestamp_text.strip], "http://twitter.com/#{from}/statuses/#{status_id}", nil, al(:class => "tweet-permalink"))
            tweet_meta << permalink
          end
          
          if source
            tweet_meta << " from "
            tweet_meta << (source_url ? doc.md_im_link([source], source_url) : source)
          end
          
          if reply_to_name and reply_to_id
            tweet_meta << doc.md_im_link([" in reply to #{reply_to_name}"], "http://twitter.com/#{reply_to_name}/statuses/#{reply_to_id}")
          end
          
          tweet_body << doc.md_div(tweet_meta, al(:class => "tweet-meta")) unless tweet_meta.empty?
          
          if from
            tweet_body << doc.md_div([
              doc.md_im_image([], avatar, nil, al(:class => "tweet-avatar")),
              doc.md_im_link([from], "http://twitter.com/#{from}", nil, al(:class => "tweet-username")),
              doc.md_div([from_real], al(:class => "tweet-realname"))
            ], al(:class => "tweet-profile"))
          end
          
          tweet = doc.md_div tweet_body, al(:class => "tweet")
          context.push tweet
          true
        end
      )
    end
  
    private
    # Constructs an AttributeList from a hash.
    def al(attributes)
      a = MaRuKu::AttributeList.new
      attributes.each { |k, v| a.push_key_val k, v }
      a
    end
  end
end
