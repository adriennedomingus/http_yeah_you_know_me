require_relative 'word_search'
require 'pry'

class PathRequest

  def initialize
    @counter = 0
  end

  def greeting
    "Hello, World! (#{@counter += 1})"
  end

  def paths(path_to_follow, words, body)
    general_output = body
    case path_to_follow
    when "/hello"
      path_output = hello
    when "/datetime"
      path_output = datetime
    when "/shutdown"
      path_output = shutdown
    when "/word_search"
      path_output = WordSearch.new.word_search(words)
    else
      path_output = general_output
    end
    path_output
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
end
