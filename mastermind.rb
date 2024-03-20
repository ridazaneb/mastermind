class Game
    attr_reader :secret_code, :attempts, :guesses
  
    def initialize(colors = %w[red blue green yellow orange purple], number_of_pegs = 4)
      @colors = colors
      @number_of_pegs = number_of_pegs
      @secret_code = generate_secret_code
      @attempts = 0
      @guesses = []
    end
  
    def generate_secret_code
      @colors.sample(@number_of_pegs)
    end
  
    def play
      puts "Welcome to Mastermind!"
      puts "You have #{@number_of_pegs} pegs and #{@colors.length} colors to choose from."
      puts "Try to guess the secret code within #{@colors.length**@number_of_pegs} attempts."
  
      while @attempts < @colors.length**@number_of_pegs
        puts "Enter your guess (#{@number_of_pegs} colors separated by spaces):"
        guess = gets.chomp.split(' ')
  
        if guess.length != @number_of_pegs
          puts "Invalid guess. Please enter #{@number_of_pegs} colors."
        else
          correct_colors = 0
          correct_positions = 0
  
          guess.each_with_index do |color, index|
            if @secret_code[index] == color
              correct_colors += 1
            elsif @secret_code.include?(color)
              correct_positions += 1
            end
          end
  
          @guesses << guess
          @attempts += 1
  
          if correct_colors == @number_of_pegs
            puts "Congratulations! You guessed the secret code in #{@attempts} attempts."
            break
          else
            puts "You have #{correct_colors} correct colors and #{correct_positions} correct positions."
          end
        end
      end
  
      if @attempts == @colors.length**@number_of_pegs
        puts "Sorry, you did not guess the secret code in the allowed number of attempts."
        puts "The secret code was #{@secret_code}."
      end
    end
  end
  
  game = Game.new
  game.play
