require 'socket'
require 'pry'
require_relative 'path'


class WebServer
  attr_reader :client, :request_lines, :counter, :path

  def initialize
    @server = TCPServer.new(9292)
    @total_pings = 0
    @path = PathRequest.new(request_lines, @total_pings)
  end

  def start_server
    @total_pings += 1
    @request_lines = []
    @client = @server.accept

  end

  def format_response
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def html_response
    path_extension = PathRequest.new(request_lines, @total_pings).path_request
    binding.pry
    puts "Got this request:"
    puts request_lines.inspect
    puts "sending response."
    response = "<pre>" + path_extension + "</pre>"
  end

  def server_response
    response = html_response
    @output = "<html><head></head><body>#{response}</body></html>"
    @headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
    client.puts @headers
    client.puts @output
  end

  def game_server_response
    response = html_response
    # path_extension = PathRequest.new(request_lines, @total_pings, redirect).path_request
    # # binding.pry
    # puts "Got this request:"
    # puts request_lines.inspect
    # puts "sending response."
    # response = "<pre>" + path_extension + "</pre>"
    @output = "<html><head></head><body>#{response}</body></html>"
    @headers = ["HTTP/1.1 302 Found",
               "Location: http://127.0.0.1:9292/game\r\n\r\n"].join("\r\n")
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
      html_response
      binding.pry
      if path.redirect?
        game_server_response
      else
        server_response
      end
      end_response
      if request_lines[0].split[1] == "/shutdown"
        break
      end
    end
  end
end


if __FILE__ == $0
  server = WebServer.new.run!
end
