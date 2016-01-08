require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'hurley'
require 'socket'
require_relative '../lib/web_server_2'

class ServerTest < Minitest::Test

  def setup
    @request_lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "Postman-Token: caad7182-899e-751e-acc0-dab87a96eca0", "Accept: */*", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    @time = Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
  end

  def test_response
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.get("http://127.0.0.1:9292")
    assert response.success?
    assert_equal "127.0.0.1", client.host
    assert_equal 9292, client.port
  end

  def test_client_returns_body
    skip
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.get("http://127.0.0.1:9292")
    result = "<html><head></head><body><pre>Hello, World! (1)\n\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nUser-Agent: Hurley v0.2\nPort: \nOrigin:  Hurley v0.2\n</pre></body></html>"
    assert_equal result, response.body
  end

  def test_path_output_for_greeting
    skip
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.get("http://127.0.0.1:9292/hello")
    result = "<html><head></head><body><pre>Hello, World! (1)</pre></body></html>"
    assert_equal result, response.body
  end

  def test_response_when_path_is_date_time
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.get("http://127.0.0.1:9292/datetime")
    result = "<html><head></head><body><pre>#{@time}</pre></body></html>"
    assert_equal result, response.body
  end

  def test_response_when_path_is_word_search_with_parameter_values
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.get("http://127.0.0.1:9292/word_search?word=snow")
    result = "<html><head></head><body><pre>SNOW is a known word</pre></body></html>"
    assert_equal result, response.body
  end

  def test_response_when_path_is_game_with_guess
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.get("http://127.0.0.1:9292/word_search?word=snow")
    result = "<html><head></head><body><pre>SNOW is a known word</pre></body></html>"
    assert_equal result, response.body
  end

  def test_response_when_path_is_start_game
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.post("http://127.0.0.1:9292/start_game")
    result = "<html><head></head><body><pre>Good luck!</pre></body></html>"
    assert_equal result, response.body
  end

  def test_response_when_path_is_game_and_wrong_guess_is_made
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.post("http://127.0.0.1:9292/game?=35")
    result = "<html><head></head><body><pre>You have made 2 guess(es)
Your guess was 35, which is too low.</pre></body></html>"
    assert_equal result, response.body
  end

  def test_response_when_path_is_game_and_correct_guess_is_made
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.post("http://127.0.0.1:9292/game?=72")
    result = "<html><head></head><body><pre>You have made 1 guess(es)
Your guess was 72, which is correct!</pre></body></html>"
    assert_equal result, response.body
  end

  def test_response_body_formats_response
    skip
    server = WebServer.new
    result = "Hello, World! (1)\n\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1:9292\nPort: 9292\nOrigin:  127.0.0.1:9292\nAccept: */*"
    assert_equal result, server.response_body(@request_lines)
  end

end
