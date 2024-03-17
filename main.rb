=begin
what happens?
start game
#computer generates word from list btwn 5-12 chars
starts with 10 guess
guess a letter at a time
all guesses are saved into an array
is guess is correct its displayed amongst the _ _ _ _
=end
#require 'pry'
class Hangman
  def initialize
    @words_arr = []
    File.open('google-10000-english-no-swears.txt') do |file|
      file.each_line do |line|
        @words_arr << line.strip
      end
    end
    @secret_word = ''
    @guess_count = 0
    @guess = ''
    @placeholder = []
  end

  def word_generator
    @secret_word = @words_arr.select {|word| word.length > 4 && word.length < 13}.sample.split("")
  end

  def handle_guess
    #later add in loop count
    @placeholder = Array.new(@secret_word.length,'_')
    p "secret word is #{@secret_word}"
    #text to make guess
    while @guess_count < 10
      p "player enter your guess"
      @guess = gets.chomp
      #@guess = ["a"]
      next unless @guess.length == 1 && @guess.respond_to?(:to_s)
      @guess_count += 1
      @secret_word.each_with_index do |word,index|
        if @secret_word[index].include?(@guess)
          @placeholder[index] = @guess
       end
     end
     p @placeholder
   end
   #binding.pry
    #p @placeholder
  end

  def start_game
    word_generator
    handle_guess
  end
end

game = Hangman.new
game.start_game
