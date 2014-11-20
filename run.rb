require './markov.rb'
require 'pry'
require 'pry-nav'
markov = Markov.new
markov.get_text("./text.txt")
binding.pry