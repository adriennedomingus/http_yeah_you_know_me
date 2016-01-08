class Game
  attr_reader :number_to_guess, :guess_counter

  def initialize
    @number_to_guess = Random.rand(0..100)
    @guess_counter   = 0
  end

  def game(parameter_value, verb)
    if verb    == "GET"
      play_game
    elsif verb == "POST"
      @redirect        = true
      @parameter_value = parameter_value[0].to_i
      "storing your guess"
    end
  end

  def play_game
    @redirect = false
    if @parameter_value
      make_a_guess(@parameter_value)
    else
      "You did not make a guess!"
    end
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

  def redirect?
    @redirect
  end
end
