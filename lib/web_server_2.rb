require 'socket'
require 'pry'
require_relative 'path'

class WebServer

  attr_reader :client, :request_lines, :path_extension, :counter

  def initialize
    @server = TCPServer.new(9292)
    @counter = 0
  end

  def start_server
    @counter += 1
    @request_lines = []
    @client = @server.accept
  end

  def format_response
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def server_response
    path_extension = PathRequest.new(request_lines, counter).path_request
    puts "Got this request:"
    puts request_lines.inspect
    puts "sending response."
    response = "<pre>" + path_extension + "</pre>"
    @output = "<html><head></head><body>#{response}</body></html>"
    @headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
    client.puts @headers
    client.puts @output
  end

  def end_response
    puts ["Wrote this response:", @headers, @output].join("\n")
    client.close
    puts "\nResponse complete, exiting."
  end

  def run!
    loop do
      start_server
      format_response
      server_response
      end_response
    end
  end
end


if __FILE__ == $0
  server = WebServer.new.run!
end
