require './markov.rb'
require 'pry'
require 'pry-nav'
markov = Markov.new
markov.get_text("./text.txt")
5.times do
  puts markov.generate_sentence
end
binding.pry