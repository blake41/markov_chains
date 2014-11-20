require 'pry'
require 'pry-nav'
class MarkovChainer
   attr_reader :order
   def initialize(order)
     @order = order
     @beginnings = []
     @freq = {}
   end

   def add_text(text)
     # make sure each paragraph ends with some sentence terminator
     text.gsub!(/\n\s*\n/m, ".")
     text << "."
     seps = /([.!?])/
     sentence = ""
     # binding.pry
     text.split(seps).each { |p|
      # binding.pry
       if seps =~ p
         add_sentence(sentence, p)
         sentence = ""
       else
         sentence = p
       end
     }
     binding.pry
   end

   def generate_sentence
     res = @beginnings[rand(@beginnings.size)]
     loop {
       unless nw = next_word_for(res[-order, order])
         return res[0..-2].join(" ") + res.last
       end
       res << nw
     }
   end

   private

   def add_sentence(str, terminator)
    # binding.pry
     words = str.scan(/[\w']+/)
     return unless words.size > order # ignore short sentences
     words << terminator
     buf = []
     words.each { |w|
      # binding.pry
       buf << w
       if buf.size == order + 1
        binding.pry
         (@freq[buf[0..-2]] ||= []) << buf[-1]
         buf.shift
       end
     }
     @beginnings << words[0, order]
   end

   def next_word_for(words)
     arr = @freq[words]
     arr && arr[rand(arr.size)]
   end

end


if $0 == __FILE__
   order = 2
   n = 10
   while ARGV[0] =~ /\A-([on])([1-9]\d*)\z/
     if $1 == "o"
       order = Integer($2)
     else
       n = Integer($2)
     end
     ARGV.shift
   end
   mc = MarkovChainer.new(order)
   mc.add_text(ARGF.read)
   n.times {
     puts mc.generate_sentence
   }
end
