require 'socket'

    @tcp_server = TCPServer.open(9292)
    $counter = 0

  loop do
    @request_lines = []
    @client = @tcp_server.accept
    while line = @client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    puts "Ready for a request"
    $counter += 1

    puts "Got this request:"
    puts @request_lines.inspect
    @greeting = "Hello, World! (#{$counter})"

    case @request_lines[0].split[1]
    when "/hello"
      @path_output = @greeting
    when "/datetime"
      Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
    when "/shutdown"
      @path_output = "Total requests: #{$counter}"
    else
      request_lines = @request_lines
      verb = "Verb: #{request_lines[0].split[0]}"
      path = "Path: #{request_lines[0].split[1]}"
      protocol = "Protocol: #{request_lines[0].split[2]}"
      host = "#{request_lines[1]}"
      port = "Port: #{request_lines[1].split(":")[2]}"
      origin = "Origin: #{request_lines[1].split(":")[1,2].join(":")}"
      accept = "#{request_lines[3]}"
      @formatted_request_lines = [verb, path, protocol, host, port, origin, accept]
      @path_output = @greeting + ("\n\n") + @formatted_request_lines.join("\n")
    end

    puts "sending response."
     response_1 = "<pre>" + @path_output + "</pre>"
     @output = "<html><head></head><body>#{response_1}</body></html>"
     @headers = ["http/1.1 200 ok",
           "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
           "server: ruby",
           "content-type: text/html; charset=iso-8859-1",
           "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
     @client.puts @output


    puts ["Wrote this response:", @headers, @output].join("\n")
    @client.close
    puts "\nResponse complete, exiting."

    if @request_lines[0].split[1] == "/shutdown"
      break
    end
  end
