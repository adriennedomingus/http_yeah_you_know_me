require 'minitest/autorun'
require 'minitest/pride'
require 'hurley'
require 'socket'
#require_relative '../lib/web_server'

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

  # def test_client_returns_body
  #   response = client.get("http://127.0.0.1:9292")
  #   assert_equal
  #     '<html><head></head><body><pre>Hello, World! (14)
  #
  #     Verb: GET
  #     Path: /
  #     Protocol: HTTP/1.1
  #     User-Agent: Hurley v0.2
  #     Port:
  #     Origin:  Hurley v0.2
  #     Accept: */*</pre></body></html>', response.body
  # end
end
