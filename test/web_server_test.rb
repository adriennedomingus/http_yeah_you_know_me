require 'minitest/autorun'
require 'minitest/pride'
require 'hurley'
require 'socket'
require_relative '../lib/web_server_2'

class ServerTest < Minitest::Test

  attr_reader :client

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
  end

  def test_response
    response = client.get("http://127.0.0.1:9292")
    assert response.success?
    assert_equal "127.0.0.1", client.host
    assert_equal 9292, client.port
  end

  def test_client_returns_body
    response = client.get("http://127.0.0.1:9292")
    result = "<html><head></head><body><pre>Hello, World! (0)\n\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nUser-Agent: Hurley v0.2\nPort: \nOrigin:  Hurley v0.2\nConnection: close</pre></body></html>"
    assert_equal result, response.body
  end
  #
  # def test_initial_request_lines_is_empty_array
  #   WebServer.new.response_body
  #   assert_equal [], @request_lines
  # end

end
