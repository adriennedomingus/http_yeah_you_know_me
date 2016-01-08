require_relative 'word_search'
require_relative 'game'

class PathRequest
  attr_reader :counter, :hello_counter

  def initialize
    @counter       = 0
    @hello_counter = 0
    @redirect      = false
  end

  def main_greeting
    "Hello, World! (#{counter})"
  end

  def hello_greeting
    "Hello, World! (#{@hello_counter += 1})"
  end

  def paths(path_to_follow, parameter_value, format_response, verb)
    increase_counter(path_to_follow)
    case path_to_follow
    when "/hello"
      path_output = hello_greeting
    when "/datetime"
      path_output = datetime
    when "/shutdown"
      path_output = shutdown
    when "/word_search"
      path_output = WordSearch.new.word_search(parameter_value)
    when "/start_game"
      path_output = start_game
    when "/game"
      path_output = @game_player.game(parameter_value, verb)
    else
      path_output = ""
    end
  end

  def increase_counter(path_to_follow)
    if path_to_follow != "/favicon.ico"
      @counter += 1
    end
  end

  def datetime
    Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
  end

  def shutdown
    "Total requests: #{counter}"
  end

  def start_game
    @game_player = Game.new
    "Good luck!"
  end

  def redirect?
    @game_player ? @game_player.redirect? : false
  end

end
