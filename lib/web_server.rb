require 'socket'

class Server

  attr_accessor :client, :request_lines

  def initialize
    tcp_server = TCPServer.open(9292)
    @client = tcp_server.accept
    $counter = 0
    @request_lines = []
  end

  def client_request
    puts "Ready for a request"
    @request_lines = []
    while line = @client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    $counter += 1
  end

  def greeting
    puts "Got this request:"
    puts @request_lines.inspect
    @greeting = "Hello, World! (#{$counter})"
  end

  def to_browser
    @path_output = path
  end

  def command_line_output
    to_browser
    puts "sending response."
    response_1 = "<pre>" + @path_output+ "</pre>"
    @output = "<html><head></head><body>#{response_1}</body></html>"
    @headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
    client.puts @output
  end

  def path
    case @request_lines[0].split[1]
    when "/hello"
      @greeting
    when "/datetime"
      Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
    when "/shutdown"
      "Total requests: #{$counter}"
      # close
    when "/"
      request_lines = @request_lines
      verb = "Verb: #{request_lines[0].split[0]}"
      path = "Path: #{request_lines[0].split[1]}"
      protocol = "Protocol: #{request_lines[0].split[2]}"
      host = "#{request_lines[1]}"
      port = "Port: #{request_lines[1].split(":")[2]}"
      origin = "Origin: #{request_lines[1].split(":")[1,2].join(":")}"
      accept = "#{request_lines[4]}"
      @formatted_request_lines = [verb, path, protocol, host, port, origin, accept]
      greeting + ("\n\n") + @formatted_request_lines.join("\n")
    end
    # client_request
  end

  # def close
  #   puts ["Wrote this response:", @headers, @output].join("\n")
  #   client.close
  #   puts "\nResponse complete, exiting."
  # end
end

s = Server.new
s.client_request
s.greeting
s.to_browser
s.command_line_output
