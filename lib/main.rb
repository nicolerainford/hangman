# error text if I type in wrong file name
require 'yaml'
require_relative 'database'

class Hangman
  # need to add attr accessor
  attr_accessor :secret_word, :placeholder, :victory, :guess_array, :guess_count

  include Database
  def initialize
    @words_arr = []
    File.open('../google-10000-english-no-swears.txt') do |file|
      file.each_line do |line|
        @words_arr << line.strip
      end
    end
    @secret_word = ''
    @guess_count = 10
    @guess = ''
    @placeholder = []
    @victory = false
    @guess_array = []
  end

  def word_generator
    # @secret_word = @words_arr.select { |word| word.length > 4 && word.length < 13 }.sample.split('')
    @secret_word = %w[a a a]
  end

  def update_placeholder
    @secret_word.each_with_index do |_word, index|
      # if @secret_word[index].include?(@guess) && !@guess_array.include?(@guess)
      @placeholder[index] = @guess if @secret_word.include?(@guess) && !@guess_array.include?(@guess)
    end
  end

  def check_guess_result
    puts "check guess result"

    if @secret_word.include?(@guess)
      p "true"
    else p "false"
    end
    if @secret_word.include?(@guess) && !victory?
      puts 'Good guess!'
    elsif !@secret_word.include?(@guess) && !@guess_array.include?(@guess)
      puts 'No luck!'
      @guess_count -= 1
    elsif @guess_array.include?(@guess)
      puts "You guessed that already"
    end
  end

  def victory?
    # p "value of victory is #{@victory}"
    return unless @placeholder === @secret_word

    @victory = true
    p 'You have won!'
  end

  def start_choice
    user_choice = 0
    user_choice = gets.chomp
    until user_choice === '1' || user_choice === '2'
      puts 'Please input either 1 or 2'
      user_choice = gets.chomp
    end
    if user_choice === '1'
      word_generator
      handle_guess
    elsif user_choice === '2'
      load_saved_file
      handle_guess
    end
  end

  def handle_guess
    #later add in loop count
    @placeholder = Array.new(@secret_word.length, '_')
    p "secret word is #{@secret_word}"
    # text to make guess
    while !@victory && @guess_count > 0
      puts 'player enter your guess'
      @guess = gets.chomp
      #puts "#{@guess.length}"
      if @guess === 'save'
        puts 'Enter name for saved game'
        game_name = gets.chomp
        save_game(game_name)
      # elsif @guess.length > 1 || !(@guess.is_a?(String))
      elsif @guess.length > 1 || !('a'..'z').include?(@guess)
        while @guess.length > 1 || !('a'..'z').include?(@guess)
            puts 'please only enter one letter'
          @guess = gets.chomp
        end
      end
      next unless @guess.length == 1 && ('a'..'z').include?(@guess)

      update_placeholder
      break if victory?

      # victory?
      check_guess_result
      #puts "guess result checked"
      # break if victory?
      @guess_array << @guess unless @guess_array.include?(@guess)
      p "You have #{@guess_count} incorrect guesses remaining" if @guess_count >= 1 && !@secret_word.include?(@guess)
      puts "Letters guessed: #{@guess_array}" unless victory?
      p @placeholder
      puts 'Out of guesses' if @guess_count == 0 && !victory?
    end
  end

  def start_game
    puts 'Welcome to terminal hangman'
    puts 'A random word with 5-12 letters will be chosen. On each turn, you can guess one letter. A random word with 5-12 letters will be chosen. On each turn, you can guess one letter.'
    puts 'To win you must find all letters in the word before using 10 incorrect guesses '
    puts 'Would you like to:'
    puts display_start_choice
    start_choice
    word_generator
    handle_guess
  end
end

game = Hangman.new
game.start_game

word_generator
handle_guess
