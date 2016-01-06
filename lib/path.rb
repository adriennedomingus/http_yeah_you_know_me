require_relative 'web_server_2'
require 'pry'

class PathRequest
    attr_reader :request_lines, :counter
  def initialize(request_lines, counter)
    @counter = counter
    @request_lines = request_lines

  end

  def path_request
    request_lines
    # @counter += 1
    case request_lines[0].split(/[\s?]/)[1]
    when "/hello"
      greeting
    when "/datetime"
      datetime
    when "/shutdown"
      shutdown
    when "/word_search"
      word_search
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

  def greeting
    "Hello, World! (#{counter})"
  end

  def datetime
    Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
  end

  def shutdown
    "Total requests: #{counter}"
  end

end
