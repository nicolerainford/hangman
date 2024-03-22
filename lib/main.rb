# what happens?
# start game
# computer generates word from list btwn 5-12 chars
# starts with 10 guess
# guess a letter at a time
# all guesses are saved into an array
# is guess is correct its displayed amongst the _ _ _ _
# need victory? method
# need an array of guesses so far
# only display
require 'yaml'
require './database'

class Hangman
  #need to add attr accessor
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
    if @secret_word.include?(@guess) && !victory?
      puts 'Good guess!'
    elsif !@secret_word.include?(@guess) && !@guess_array.include?(@guess)
      puts 'No luck!'
      @guess_count -= 1
    elsif @secret_word.include?(@guess) && @guess_array.include?(@guess)
      puts "You've already guessed that letter!"
    end
    # puts "You've already guessed that letter!" if @guess_array.include?(@guess)
  end

  def victory?
    #p "value of victory is #{@victory}"
    return unless @placeholder === @secret_word

    @victory = true
    p 'You have won!'
  end

  def handle_guess
    puts "Welcome to terminal hangman"
    puts "A random word with 5-12 letters will be chosen. On each turn, you can guess one letter. A random word with 5-12 letters will be chosen. On each turn, you can guess one letter."
    puts "To win you must find all letters in the word before using 10 incorrect guesses "
    puts "Would you like to:"
    puts display_start_choice
    # later add in loop count
    @placeholder = Array.new(@secret_word.length, '_')
    p "secret word is #{@secret_word}"
    # text to make guess
    while !@victory && @guess_count > 0
      p 'player enter your guess'
      @guess = gets.chomp
      #next unless @guess.length == 1 && @guess.respond_to?(:to_s)
      if @guess === "save"
        puts "Enter name for saved game"
        game_name = gets.chomp
        save_game(game_name)
      elsif @guess === "load"
          #puts "Here are the current saved games. Please choose which you'd like to load."
          #game_name = gets.chomp
          #load_game(game_name)
          load_saved_file
          p @placeholder
        else next unless @guess.length == 1 && @guess.respond_to?(:to_s)
      end
      update_placeholder
      break if victory?

      # victory?
      check_guess_result
      # break if victory?
      @guess_array << @guess unless @guess_array.include?(@guess)
      p "You have #{@guess_count} incorrect guesses remaining" if @guess_count >= 1 && !@secret_word.include?(@guess)
      puts "Letters guessed: #{@guess_array}" unless victory?
      p @placeholder
      puts 'Out of guesses' if @guess_count == 0 && !victory?
    end
  end

  def start_game
    word_generator
    handle_guess
  end
end

game = Hangman.new
game.start_game
