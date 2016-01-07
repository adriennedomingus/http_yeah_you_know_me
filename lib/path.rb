require_relative 'word_search'
require_relative 'game'
require_relative 'web_server_2'
require 'pry'

class PathRequest

    attr_reader :request_lines, :total_pings, :parameter_values

  def initialize(request_lines, total_pings)
    @total_pings = total_pings
    @counter = 0
    @request_lines = request_lines
    @redirect = false
  end

  def path_request
    request_lines
    verb = request_lines[0].split[0]
    path = request_lines[0].split(/[\s?]/)[1]

    if path == "/hello"
      greeting
    elsif path == "/datetime"
      datetime
    elsif path == "/shutdown"
      shutdown
    elsif path == "/word_search"
      dictionary
    elsif path == "/start_game"
      start_game
    elsif path == "/game" && verb == "GET"
      @redirect = false
      play_game
    elsif path == "/game" && verb == "POST"
      @redirect = true
      binding.pry
      parameter_values
      "hello"
    else
      response_body
    end
  end

  def response_body
    request_lines
    verb = "Verb: #{request_lines[0].split[0]}"
    path = "Path: #{request_lines[0].split[1]}"
    protocol = "Protocol: #{request_lines[0].split[2]}"
    host = "#{request_lines[1]}"
    port = "Port: #{request_lines[1].split(":")[2]}"
    origin = "Origin: #{request_lines[1].split(":")[1,2].join(":")}"
    accept = "#{request_lines[4]}"
    formatted_request_lines = [verb, path, protocol, host, port, origin, accept]
    greeting + "\n\n" + formatted_request_lines.join("\n")
  end

  def redirect?
    @redirect
  end

  def greeting
    "Hello, World! (#{@counter += 1})"
  end

  def datetime
    Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
  end

  def shutdown
    "Total requests: #{total_pings}"
  end

  def parameter_values
    @parameter_values = request_lines[0].split(/[\s?&=]/)[2..-2].delete_if do |word|
      word == "word" || word == "guess"
    end
  end

  def dictionary
    WordSearch.new.word_search(parameter_values)
  end

  def play_game
    Game.new.play_game(parameter_values)
  end

  def start_game
    "Good Luck!"
  end
end
