def display_saved_games(number, name)
  <<~HEREDOC
    \e[34m[#{number}]\e[0m #{name}
  HEREDOC
end

def start_instructions
  text1 = 'Play a new game'
  text2 = 'Load a saved game'
  puts 'Welcome to terminal hangman'
  puts 'A random word with 5-12 letters will be chosen. On each turn, you can guess one letter. A random word with 5-12 letters will be chosen. On each turn, you can guess one letter.'
  puts 'To win you must find all letters in the word before using 10 incorrect guesses '
  puts 'Would you like to:'
  puts Rainbow('[1] ').blue + 'Play a new game'
  puts Rainbow('[2] ').blue + 'Load a saved game'
end

def display_letters_guessed
  puts 'Letters Guessed:' + Rainbow("#{@guess_array.join(' ')}").purple
end

def display_incorrect_guess_remaining
  if @guess_count >=4
   puts "You have " + Rainbow("#{@guess_count}").orange.bright + " incorrect guesses remaining"
  elsif @guess_count < 4 && @guess_count > 1
    puts "You have " + Rainbow("#{@guess_count}").red + " incorrect guesses remaining"
  elsif @guess_count === 1
    puts "You have " + Rainbow("#{@guess_count}").red + " incorrect guess remaining"
  end
end

