require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/word_search.rb'

class WordSearchTest < Minitest::Test

  def test_dictionary_includes_known_words
    searcher = WordSearch.new
    assert searcher.is_a_word?("hello")
    assert searcher.is_a_word?("another")
  end

  def test_dictionary_doesnt_include_non_words
    searcher = WordSearch.new
    refute searcher.is_a_word?("adlkfjad")
    refute searcher.is_a_word?("eroulkcvclk")
  end

  def test_returns_known_word
    searcher = WordSearch.new

    result = "HELLO is a known word"
    assert_equal result, searcher.word_search(["hello"])
  end

  def test_returns_unknown_word
    searcher = WordSearch.new

    result = "DSKLJF is not a known word"
    assert_equal result, searcher.word_search(["dskljf"])
  end

  def test_returns_multiple_known_words
    searcher = WordSearch.new

    result = "HELLO is a known word\nWORD is a known word\nPIZZA is a known word"
    assert_equal result, searcher.word_search(["hello", "word", "pizza"])
  end

  def test_returns_combination_of_known_and_unknown_words
    searcher = WordSearch.new

    result = "HELLO is a known word\nADFLKJ is not a known word\nPIZZA is a known word"
    assert_equal result, searcher.word_search(["hello", "adflkj", "pizza"])
  end
end
