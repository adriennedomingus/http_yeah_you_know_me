require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/path.rb'
require_relative '../lib/word_search.rb'

class PathRequestTest < MiniTest::Test

  def setup
    @response_body = "Hello, World! (1)\n\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: localhost:9292\nPort: 9292\nOrigin:  localhost:9292\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
  end

  def test_hello_greeting_says_hello
    path = PathRequest.new

    assert_equal "Hello, World! (1)", path.hello_greeting
  end

  def test_main_greeting_says_hello
    path = PathRequest.new

    assert_equal "Hello, World! (0)", path.main_greeting
  end

  def test_hello_and_main_greetings_count_differently
    path = PathRequest.new

    path.paths("/hello", [], @response_body, "GET")
    path.paths("/", [], @response_body, "GET")
    path.paths("/datetime", [], @response_body, "GET")
    assert_equal 1, path.hello_counter
    assert_equal 3, path.counter
  end

  def test_hello_path_returns_greeting
    path = PathRequest.new

    assert_equal "Hello, World! (1)", path.paths("/hello", [], @response_body, "GET")
  end

  def test_datetime_path_returns_date
    path = PathRequest.new

    assert_equal Time.now.strftime('%a, %e %b %Y %H:%M:%S %z'), path.paths("/datetime", [], @response_body, "GET")
  end

  def test_shutdown_returns_total_requests
    path = PathRequest.new
    47.times do
      path.paths("/hello", [], @response_body, "GET")
    end
    assert_equal "Total requests: 48", path.paths("/shutdown", [], @response_body, "GET")
  end

  def test_word_search_returns_whether_words_are_known_or_not
    path = PathRequest.new

    result = "HELLO is a known word\nPIZZA is a known word\nAJDLKFJAL is not a known word"
    assert_equal result, path.paths("/word_search", ["hello", "pizza", "ajdlkfjal"], @response_body, "GET")
  end

  def test_blank_path_returns_response_body
    path = PathRequest.new

    result = "Hello, World! (1)\n\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: localhost:9292\nPort: 9292\nOrigin:  localhost:9292\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"

    assert_equal result, path.paths("/", [], @response_body, "GET")
  end

  def test_game_path_post_verb_sets_redirect_to_true
    path = PathRequest.new

    path.paths("/start_game", [], @response_body, "POST")
    path.paths("/game", [], @response_body, "POST")
    assert path.redirect?
  end

  def test_start_game_wishes_you_luck
    path = PathRequest.new

    result = "Good luck!"
    assert_equal result, path.paths("/start_game", [], @response_body, "POST")
  end

  def test_game_without_a_guess
    path = PathRequest.new

    path.paths("/start_game", [], @response_body, "POST")
    refute @redirect
    result = "You did not make a guess!"
    assert_equal result, path.paths("/game", [], @response_body, "GET")
  end

  def test_different_responses_with_multiple_requests
    path = PathRequest.new

    result1 = Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
    result2 = "Hello, World! (1)\n\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: localhost:9292\nPort: 9292\nOrigin:  localhost:9292\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    result3 = "Hello, World! (1)"

    assert_equal result1, path.paths("/datetime", [], @response_body, "GET")
    assert_equal result2, path.paths("/", [], @response_body, "GET")
    assert_equal result3, path.paths("/hello", [], @response_body, "GET")
  end

end
