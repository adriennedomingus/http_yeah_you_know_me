class Game

  def initialize
    @number_to_guess = 72
    @guess_counter = 0
  end

  def play_game(guess)
    guess = guess[0].to_i
    if guess > @number_to_guess
      response = "too high"
      @guess_counter += 1
    elsif guess < @number_to_guess
      response = "too low"
      @guess_counter += 1
    elsif guess == @number_to_guess
      response = "correct!"
      @guess_counter += 1
    end
    "You have made #{@guess_counter} guess(es)\nYour guess was #{guess}, which is #{response}"
  end
end
