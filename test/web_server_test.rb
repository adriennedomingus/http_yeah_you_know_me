require 'simplecov'
SimpleCov.start
require 'Minitest/autorun'
require 'Hurley'
require_relative '../lib/web_server'

class ServerTest < Minitest::Test

  def test_response_success
    client = Hurley::Client.new "http://127.0.0.1:9292"
  end
end
