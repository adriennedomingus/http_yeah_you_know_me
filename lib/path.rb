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
    "Hello, World! (#{counter})"
  end

  def paths(path_to_follow, parameter_value, response_body, verb)
    increase_counter(path_to_follow)
    case path_to_follow
    when "/hello"
      path_output = hello
    when "/datetime"
      path_output = datetime
    when "/shutdown"
      path_output = shutdown
    when "/word_search"
      path_output = WordSearch.new.word_search(parameter_value)
    when "/start_game"
      path_output = start_game
    when "/game"
      path_output = game(parameter_value, verb)
    else
      path_output = response_body
    end
  end

  def increase_counter(path_to_follow)
    if path_to_follow != "/favicon.ico"
      @counter += 1
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
    "Total requests: #{counter}"
  end

  def start_game
    "Good luck!"
  end

  def game(parameter_value, verb)
    if verb == "GET"
      play_game(parameter_value, verb)
    elsif verb == "POST"
      @redirect = true
      @parameter_value = parameter_value[0].to_i
      "guess"
    end
  end

  def play_game(parameter_value, verb)
    @redirect = false
    if @parameter_value != nil
      Game.new.make_a_guess(@parameter_value)
    else
      "You did not make a guess!"
    end
  end
end
