require 'socket'
require 'pry'
require_relative 'path'

class WebServer

  attr_reader :client, :request_lines, :path_output, :path_options

  def initialize
    @server = TCPServer.new(9292)
    @path_options = PathRequest.new
  end

  def start_server
    @request_lines = []
    @client = @server.accept
  end

  def format_request
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def server_output
    general_output = body
    path_output = path_options.paths(@path.split(/[\s?&]/)[1], @path.split(/[\s?&]/)[2..-1], general_output)
    puts "Got this request:"
    puts request_lines.inspect
    puts "sending response."
    response = "<pre>" + path_output + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
  end

  def body
    request_lines = format_request
    verb = "Verb: #{request_lines[0].split[0]}"
    @path = "Path: #{request_lines[0].split[1]}"
    protocol = "Protocol: #{request_lines[0].split[2]}"
    host = "#{request_lines[1]}"
    port = "Port: #{request_lines[1].split(":")[2]}"
    origin = "Origin: #{request_lines[1].split(":")[1,2].join(":")}"
    accept = "#{request_lines[4]}"
    formatted_request_lines = [verb, @path, protocol, host, port, origin, accept]
    @path_options.greeting + "\n\n" + formatted_request_lines.join("\n")
  end

  def run!
    loop do
      start_server
      server_output
      # paths
      if request_lines[0].split[1] == "/shutdown"
        break
      end
    end
  end
end


if __FILE__ == $0
  WebServer.new.run!
end
