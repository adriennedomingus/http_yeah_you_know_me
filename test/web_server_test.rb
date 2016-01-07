require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'hurley'
require 'socket'
require_relative '../lib/web_server_2'

class ServerTest < Minitest::Test

  def test_response
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.get("http://127.0.0.1:9292")
    assert response.success?
    assert_equal "127.0.0.1", client.host
    assert_equal 9292, client.port
  end

  def test_client_returns_body
    client = Hurley::Client.new "http://127.0.0.1:9292"
    response = client.get("http://127.0.0.1:9292")
    result = "<html><head></head><body><pre>Hello, World! (0)\n\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nUser-Agent: Hurley v0.2\nPort: \nOrigin:  Hurley v0.2\nConnection: close</pre></body></html>"
    assert_equal result, response.body
  end

  def request_lines_are_empty?
    server = Server.new

    assert server.request_lines.empty?
  end

  def 

end
