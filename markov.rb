class Markov

  attr_reader :order, :freq, :beginnings, :terminators

  def initialize(order = 2)
    @order = order
    @freq = Hash.new {|hash, key| hash[key] = []}
    @beginnings = []
    @terminators = /([?.!])/
  end

  def get_text(path)
    file = File.read(path)
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
    words << terminator
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

  def generate_sentence
    sentence = []
    first_two = start_sentence
    sentence << first_two[0] << first_two[1]
    next_word = ""
    until terminators =~ next_word
      next_word = get_next(sentence[-2..-1])
      sentence << next_word
    end
    sentence.join(" ")
  end

  def get_next(last_words)
    freq[last_words].sample
  end

  def start_sentence
    beginnings.sample
  end

end

# split on paragraphs and periods