require 'socket'
require_relative 'path'

class WebServer
  include Enumerable

  def each(&block)

  end

  attr_reader :client, :request_lines, :path_output, :path_options, :output, :headers

  def initialize
    @server = TCPServer.new(9292)
    @path_options = PathRequest.new
  end

  def start_server
    @client = @server.accept
  end

  def format_response
    @request_lines = []
    while line = client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    request_lines
  end

  def command_line_output(response_body)
    verb = "#{request_lines[0].split[0]}"
    path = request_lines[0].split(/[\s?&=]/)
    parameter_value = []
    path[2..-2].each_with_index do |word, index|
        if index.odd?
          parameter_value << word
      end
    end
    path_output = path_options.paths(path[1], parameter_value, response_body, verb)
    puts "Got this request:"
    puts request_lines.inspect
    puts "sending response."
    @response = "<pre>" + path_output + "</pre>"
  end

  def server_response
    @output = "<html><head></head><body>#{@response}</body></html>"
    @headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
  end

  def game_server_response
    @output = "<html><head></head><body>#{@response}</body></html>"
    @headers = ["HTTP/1.1 302 Found",
                "Location: http://127.0.0.1:9292/game\r\n\r\n",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
  end

  def response_body(format_response)
    puts "*****************************"
    puts request_lines.inspect
    verb = "Verb: #{request_lines[0].split[0]}"
    path = "Path: #{request_lines[0].split[1]}"
    protocol = "Protocol: #{request_lines[0].split[2]}"
    host = "#{request_lines[1]}"
    port = "Port: #{request_lines[1].split(":")[2]}"
    origin = "Origin: #{request_lines[1].split(":")[1,2].join(":")}"
    accept = "#{request_lines[4]}"
    formatted_request_lines = [verb, path, protocol, host, port, origin, accept]
    path_options.greeting + "\n\n" + formatted_request_lines.join("\n")
  end

  def end_response
    puts ["Wrote this response:", headers, output].join("\n")
    client.close
    puts "\nResponse complete, exiting."
  end

  def run!
    loop do
      start_server
      command_line_output(response_body(format_response))
      path_options.redirect? ? game_server_response : server_response
      end_response
      break if request_lines[0].split[1] == "/shutdown"
    end
  end
end


if __FILE__ == $0
  WebServer.new.run!
end
