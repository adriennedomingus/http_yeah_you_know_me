require 'socket'

class Server
  def initialize
    @tcp_server = TCPServer.open(9292)
    @counter = 0
  end
  #
  # def split_request_lines
  #   request_lines = @request_lines.each do |line|
  #     line.split(/[\s?:]/)
  #   end
  # end

  def greeting
    @greeting = "Hello, World! (#{@counter})"
  end

  def command_line_output
    puts "Got this request:"
    puts @request_lines.inspect
    puts "sending response."
    response_1 = "<pre>" + @path_output + "</pre>"
    @output = "<html><head></head><body>#{response_1}</body></html>"
    @headers = ["http/1.1 200 ok",
           "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
           "server: ruby",
           "content-type: text/html; charset=iso-8859-1",
           "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
    @client.puts @headers
    @client.puts @output
  end

  def close
    puts ["Wrote this response:", @headers, @output].join("\n")
    @client.close
    puts "\nResponse complete, exiting."
  end

#end base server

#paths class?

  def paths
    case @request_lines[0].split(/[\s?]/)[1]
    when "/hello"
      @path_output = hello
    when "/datetime"
      @path_output = datetime
    when "/shutdown"
      @path_output = shutdown
    when "/word_search"
      @path_output = word_search
    else
      @path_output = no_path
    end
  end

  def hello
    @greeting
  end

  def datetime
    Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
  end

  def shutdown
    "Total requests: #{@counter}"
  end

  def word_search
    words = @request_lines[0].split(/[\s?&]/)[2..-2]
    words.map do |word|
      if is_a_word? word
        "#{word.upcase} is a known word"
      else
        "#{word.upcase} is not a known word"
      end
    end.join("\n")
  end

  def is_a_word?(word)
    dictionary = File.read("/usr/share/dict/words").split("\n")
    dictionary.include?(word)
  end

  def no_path
    request_lines = @request_lines
    verb = "Verb: #{request_lines[0].split[0]}"
    path = "Path: #{request_lines[0].split[1]}"
    protocol = "Protocol: #{request_lines[0].split[2]}"
    host = "#{request_lines[1]}"
    port = "Port: #{request_lines[1].split(":")[2]}"
    origin = "Origin: #{request_lines[1].split(":")[1,2].join(":")}"
    accept = "#{request_lines[3]}"
    @formatted_request_lines = [verb, path, protocol, host, port, origin, accept]
    @greeting + ("\n\n") + @formatted_request_lines.join("\n")
  end


  def client_access
    @request_lines = []
    @client = @tcp_server.accept
    while line = @client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    puts "Ready for a request"
    @counter += 1
  end
# Step A
#  -> Step B
#     -> Step C
#       -> Step D

# Top Level
#  -> Step A
#  <- data
# -> Step B (data)
#  <- data
#

  def run!
    loop do
      client = @tcp_server.accept
      # request = read_request(client)
      # response = generate_response(request)
      # client.write_response
      # client.close
      client_access
      greeting
      paths
      command_line_output
      close
      if @request_lines[0].split[1] == "/shutdown"
        break
      end
    end
  end
end

if __FILE__ == $0
  Server.new.run!
end