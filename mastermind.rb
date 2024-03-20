# Lab 1 COMP 318
#Mastermind Game by S. Rida Zaneb

class Game #class that deals with the Gameplay
  attr_reader :secret_code, :attempts, :guesses

  def initialize(player:, computer:, colors: %w[red blue green yellow orange purple], number_of_pegs: 4, max_attempts: 5)
    @player = player
    @computer = computer
    @colors = colors
    @number_of_pegs = number_of_pegs
    @secret_code = generate_secret_code
    @attempts = 0
    @max_attempts = max_attempts
    @guesses = []
  end

  def generate_secret_code
    @colors.sample(@number_of_pegs)
  end

  def start
    display_welcome_message
    loop do
      if player_turn
        break if game_over?
      end
      if computer_turn
        break if game_over?
      end
    end
    display_goodbye_message
  end

  private

  def player_turn
    @attempts += 1
    guess = @player.guess(@number_of_pegs, @colors)
    unless valid_guess?(guess)
      puts "Invalid guess. Please enter #{@number_of_pegs} colors separated by spaces."
      return false
    end
    @guesses << guess
    @player.check_guess(@guesses.last, @secret_code)
  end

def computer_turn
  guess = @computer.guess
  @guesses << guess
  @attempts += 1
  feedback = @player.check_guess(guess, @secret_code)
  puts "Computer's guess: #{guess.join(' ')}"
  puts "Feedback: #{feedback[0]} correct colors and #{feedback[1]} correct positions."
  feedback == [@number_of_pegs, @number_of_pegs]  
end

def game_over?
  if @guesses.last == @secret_code
    puts "Congratulations! You guessed the secret code in #{@attempts} attempts."
    return true
  elsif @attempts >= @max_attempts
    puts "Game over! You've run out of attempts. The secret code was #{@secret_code}."
    return true
  end
  false
end

  def valid_guess?(guess)
    guess.length == @number_of_pegs && guess.all? { |color| @colors.include?(color) }
  end

  def display_welcome_message
    puts "Welcome to Mastermind!"
    puts "You have #{@number_of_pegs} pegs and #{@colors.length} colors to choose from."
    puts "Try to guess the secret code within #{@max_attempts} attempts."
  end

  def display_goodbye_message
    puts "Thank you for playing!"
  end
end

class Player #class that deals with Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def guess(number_of_pegs, colors)
    puts "Enter your guess (#{number_of_pegs} colors separated by spaces):"
    gets.chomp.split(' ')
  end

  def check_guess(guess, secret)
    correct_colors = 0
    correct_positions = 0

    guess.each_with_index do |color, index|
      if guess[index] == secret[index]
        correct_positions += 1
      elsif secret.include?(color)
        correct_colors += 1
      end
    end

    puts "You have #{correct_colors} correct colors and #{correct_positions} correct positions."
    [correct_colors, correct_positions]  
  end

  def pegs_correct?(secret)
    true
  end
end


class Computer #class that deal with Computer 
  attr_reader :pegs

  def initialize(pegs)
    @pegs = pegs
  end

  def guess
    @pegs.times.map { ['red', 'blue', 'green', 'yellow', 'orange', 'purple'].sample }
  end

  def check_guess(guess, secret)
    correct_colors = 0
    correct_positions = 0

    guess.each_with_index do |color, index|
      if guess[index] == secret[index]
        correct_positions += 1
      elsif secret.include?(color)
        correct_colors += 1
      end
    end

    if correct_colors == @pegs
      puts "The computer has guessed the secret code!"
    end

    correct_positions == secret.length
  end
end

player = Player.new("Player")
computer = Computer.new(4)
game = Game.new(player: player, computer: computer)
game.start
