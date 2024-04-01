require 'yaml'
require 'rainbow'
require_relative 'database'
require_relative 'display'

class Hangman
  attr_accessor :secret_word, :placeholder, :victory, :guess_array, :guess_count

  include Database
  def initialize
    @words_arr = []
    file_path = File.expand_path('../google-10000-english-no-swears.txt', __dir__)
    File.open(file_path) do |file|
      file.each_line do |line|
        @words_arr << line.strip
      end
    end
    @secret_word = ''
    @guess_count = 10
    @guess = ''
    @victory = false
    @guess_array = []
    @game_over = false
  end

  def word_generator
    @secret_word = @words_arr.select { |word| word.length > 4 && word.length < 13 }.sample.split('')
    @placeholder = Array.new(@secret_word.length, '_')
  end

  def update_placeholder
    @secret_word.each_with_index do |_word, index|
      @placeholder[index] = @guess if @secret_word[index] == (@guess) && !@guess_array.include?(@guess)
    end
  end

  def check_guess_result
    if @guess_array.include?(@guess)
      puts 'You guessed that already'
    elsif @secret_word.include?(@guess) && !victory?
      puts Rainbow('Good guess!').green
    elsif !@secret_word.include?(@guess) && !@guess_array.include?(@guess)
      puts 'No luck!'
      @guess_count -= 1
      display_incorrect_guess_remaining unless @guess_count == 0
    end
  end

  def lose_game
    return unless @guess_count === 0
    puts "Out of guesses"
    puts "The word you were trying to guess was" + Rainbow("#{@secret_word.join}")
  end

  def victory?
    return unless @placeholder === @secret_word
    @victory = true
    @game_over = true
    puts 'You have won!'
    puts "The word you were trying to guess was " +
    Rainbow("#{@placeholder.join}").cyan
    play_again
  end

  def play_again
   return unless @game_over
   puts "Would you like to play again?"
   puts Rainbow("[1]").blue + " Yes"
   puts Rainbow("[2]").blue + " No"
   user_choice = gets.chomp
   until user_choice === '1' || user_choice === '2'
     puts "Please select either 1 or 2"
     user_choice = gets.chomp
   end
   if user_choice === "1"
    @victory = false
    start_instructions
   elsif user_choice "2"
      exit
    end
  end

  def game_over?
    if guess_count === 0 || @victory
      @game_over = true
      play_again
    end
  end

  def start_choice
    user_choice = gets.chomp
    until user_choice === '1' || user_choice === '2'
      puts 'Please input either 1 or 2'
      user_choice = gets.chomp
    end
    if user_choice === '1'
      @guess_array = []
      @guess_count = 10
      word_generator
      handle_guess
    elsif user_choice === '2'
      load_saved_file
      handle_guess
    end
  end

  def handle_guess
    p "secret word is #{@secret_word}"
    while !@victory && @guess_count > 0
      puts 'player enter your guess'
      @guess = gets.chomp
      if @guess === 'save'
        save_game_choice
      elsif @guess.length > 1 || !('a'..'z').include?(@guess)
        while @guess.length > 1 || !('a'..'z').include?(@guess)
          puts 'please only enter one letter'
          @guess = gets.chomp
        end
      end
      next unless @guess.length == 1 && ('a'..'z').include?(@guess)

      update_placeholder
      victory?
      check_guess_result
      @guess_array << @guess unless @guess_array.include?(@guess)
      display_letters_guessed unless victory?
      puts @placeholder.join(" ")
      #puts 'Out of guesses' if @guess_count == 0 && !victory?
      lose_game
      game_over?
      break if victory?
    end
  end

  def start_game
    start_instructions
  end
end

game = Hangman.new
game.start_game
