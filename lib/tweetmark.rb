module Tweetmark
  class << self
    def enable
      MaRuKu::In::Markdown::register_block_extension(
        :regexp  => /^\+twitter/,
        :handler => lambda do |doc, src, context|
          src.shift_line
        
          raw_body = ""
          while src.cur_line && !(src.cur_line =~ /^\=twitter/)
            raw_body << src.shift_line
          end
          src.shift_line
          
          # Linkify Twitter usernames
          body = raw_body.split(/\b/).inject([]) do |b, word|
            if b.last.is_a? String and b.last =~ /@$/
              b << doc.md_im_link([word], "http://twitter.com/#{word}", nil, al(:class => "tweet-name"))
            else
              b << word
            end
          end
          
          tweet_body = doc.md_div body, al(:class => "tweet-body")
          tweet      = doc.md_div [tweet_body], al(:class => "tweet")
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
