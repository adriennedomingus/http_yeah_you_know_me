class WordSearch

  def word_search(words)
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
end
