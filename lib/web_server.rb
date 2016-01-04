require 'socket'
require 'pry'
  tcp_server = TCPServer.new(9292)
  client = tcp_server.accept

  puts "Ready for a request"
  request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end

  puts "Got this request:"
  puts request_lines.inspect
  # binding.pry
  greeting = "Hello, World!"

  verb = "Verb: #{request_lines[0].split[0]}"
  path = "Path: #{request_lines[0].split[1]}"
  protocol = "Protocol: #{request_lines[0].split[2]}"
  host = "#{request_lines[1]}"
  port = "Port: #{request_lines[1].split(":")[2]}"
  origin = "Origin: #{request_lines[1].split(":")[1,2].join(":")}"
  accept = "#{request_lines[3]}"
  formatted_request_lines = [verb, path, protocol, host, port, origin, accept]

  puts "sending response."
  response_1 = "<pre>" + "#{greeting}" + ("\n\n\n") + formatted_request_lines.join("\n") + "</pre>"
  output = "<html><head></head><body>#{response_1}</body></html>"
  headers = ["http/1.1 200 ok",
        "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
        "server: ruby",
        "content-type: text/html; charset=iso-8859-1",
        "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  # client.puts headers
  client.puts output

  puts ["Wrote this response:", headers, output].join("\n")
  client.close
  puts "\nResponse complete, exiting.
