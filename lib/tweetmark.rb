module Tweetmark
  class << self
    def enable
      MaRuKu::In::Markdown::register_block_extension(
        :regexp  => /^\+twitter/,
        :handler => lambda do |doc, src, context|
          src.shift_line
        
          lines = []
          while src.cur_line && !(src.cur_line =~ /^\=twitter/)
            lines.push src.shift_line
          end
          src.shift_line
        
          tweet_body = doc.md_div lines, al(:class => "tweet-body")
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
