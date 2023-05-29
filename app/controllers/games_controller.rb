require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    @letters += Array.new(10) { ('A'..'Z').to_a.sample }
    @letters.shuffle!
  end

  def score
    t1 = Time.now
    new
    @word = params[:word].downcase
    @check = valid_word?(@word, @letters)
    t2 = Time.now
    delta = t2 - t1
    @time = delta.round(2)
    if @point == 1
      @score = (@letters.count * (1.0 - (@time / 60.0)))
    else
      @score = 0
    end
  end

  def valid_word?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    if json['found'] == true && word.chars.all? == true
      @point = 1
      "Congratulations! #{@word} is a valid English word!"
    elsif json['found'] == true && word.chars.all? == false
      @point = 0
      "Sorry but #{word} can't be built out of #{grid}"
    else
      @point = 0
      "Sorry but #{@word} does not seem to be a valid English word..."
    end
  end
end
