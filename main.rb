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

class Hangman
  def initialize
    @words_arr = []
    File.open('google-10000-english-no-swears.txt') do |file|
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
    @guess_array << @guess unless @guess_array.include?(@guess)
    p "You have #{@guess_count} incorrect guesses remaining" if @guess_count >= 1 && !@secret_word.include?(@guess)
    puts "Letters guessed: #{@guess_array}" unless victory?
    p @placeholder
    puts 'Out of guesses' if @guess_count == 0 && !victory?
  end

  def victory?
    return unless @placeholder === @secret_word

    @victory = true
    p 'You have won!'
  end

  def handle_guess
    # later add in loop count
    @placeholder = Array.new(@secret_word.length, '_')
    p "secret word is #{@secret_word}"
    # text to make guess
    while !@victory && @guess_count > 0
      p 'player enter your guess'
      @guess = gets.chomp
      next unless @guess.length == 1 && @guess.respond_to?(:to_s)

      update_placeholder
      check_guess_result
      break if victory?


    end
  end

  def start_game
    word_generator
    handle_guess
  end
end

game = Hangman.new
game.start_game
