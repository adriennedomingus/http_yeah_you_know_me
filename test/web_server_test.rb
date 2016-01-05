require 'minitest/autorun'
require 'minitest/pride'
require 'hurley'
require 'socket'
require_relative '../lib/web_server'

class ServerTest < Minitest::Test

  attr_reader :client, :iterator

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
    @iterator = 0
  end

  def test_response_success
    response = Hurley.get("http://127.0.0.1:9292")
    assert response.success?
  end
end
