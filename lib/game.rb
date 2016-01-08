class Game
  attr_reader :number_to_guess, :guess_counter

  def initialize
    @number_to_guess = 72
    @guess_counter   = 0
  end

  def make_a_guess(guess)
    guess = guess.to_i
    @guess_counter += 1
    if guess > number_to_guess
      response = "too high."
    elsif guess < number_to_guess
      response = "too low."
    elsif guess == number_to_guess
      response = "correct!"
    end
    "You have made #{guess_counter} guess(es)\nYour guess was #{guess}, which is #{response}"
  end
end
