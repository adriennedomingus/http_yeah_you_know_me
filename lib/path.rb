require_relative 'word_search'
require_relative 'game'
require_relative 'web_server_2.rb'

class PathRequest

  attr_reader :counter

  def initialize
    @counter = 0
    @redirect = false
  end

  def greeting
    "Hello, World! (#{@counter += 1})"
  end

  def paths(path_to_follow, parameter_value, response_body, verb)
    general_output = response_body
    if path_to_follow == "/hello"
      path_output = hello
    elsif path_to_follow == "/datetime"
      path_output = datetime
    elsif path_to_follow == "/shutdown"
      path_output = shutdown
    elsif path_to_follow == "/word_search"
      path_output = WordSearch.new.word_search(parameter_value)
    elsif path_to_follow == "/start_game"
      path_output = start_game
    elsif path_to_follow == "/game" && verb == "GET"
      @redirect = false
      path_output = Game.new.play_game(@parameter_value)
    elsif path_to_follow == "/game" && verb == "POST"
      @redirect = true
      @parameter_value = parameter_value
      response = "redirecting"
    else
      path_output = general_output
    end
  end

  def redirect?
    @redirect
  end

  def hello
    greeting
  end

  def datetime
    Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
  end

  def shutdown
    "Total requests: #{@counter}"
  end

  def start_game
    "Good luck!"
  end

  # def game
  #   Game.new.play_game
  # end
end
