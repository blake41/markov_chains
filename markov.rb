class Markov

  attr_reader :order, :freq, :beginnings

  def initialize(order = 2)
    @order = order
    @freq = Hash.new {|hash, key| hash[key] = []}
    @beginnings = []
  end

  def get_text(path)
    file = File.read(path)
    terminators = /([?.!])/
    sentences = file.split(terminators)
    sentence = ""
    sentences.each do |thing|
      if terminators =~ thing
        add_sentence(sentence, thing)
        sentence = ""
      else
        sentence = thing
      end
    end
  end

  def add_sentence(sentence, terminator)
    words = sentence.split(" ")
    return if words.size < 3
    buffer = []
    words.each do |word|
      buffer << word
      # we essentially exit the loop early as we get to the end of the sentence
      if buffer.size == order + 1
        # key is word pairs, value is the array of words that have ever followed 
        # them (including sentence terminators)
        @freq[buffer[0,2]] << buffer.last
        buffer.shift
      end
    end
    # keep track of good ways to start a sentence.
    @beginnings << words[0,order]
  end

end

# split on paragraphs and periods