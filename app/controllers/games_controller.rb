require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample}.join
  end

  def score
    if cookies[:total_score] == nil
      @total_score = 0
    else
      @total_score = cookies[:total_score].to_i
    end
    @letters = params[:grid]
    dictionary = open("https://wagon-dictionary.herokuapp.com/#{params[:word]}")
    json = JSON.parse(dictionary.read)
    if json['found']
      @outcome = "Congratulations #{params[:word].upcase} is a valid english word!"
      @score = params[:word].length * 3
      @total_score += @score
      cookies[:total_score] = @total_score
    elsif params[:word].chars.all? { |letter| params[:word].chars.count(letter) >= @letters.count(letter) }
      @outcome = "Sorry but #{params[:word].upcase} cannot be built out of #{@letters}"
    else
      @outcome = "Sorry it's not a valid word"
    end

  end
end
