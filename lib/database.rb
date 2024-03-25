module Database
  def save_game(game_name)
    Dir.mkdir('saved') unless Dir.exist?('saved')
    #yaml = YAML.dump(self)
    filename = "../saved/#{game_name}.yaml"
    File.open(filename, 'w') do |file|
      file.write save_to_yaml
    end
    puts 'Your game has been saved. Thanks for playing!'
    exit
  end

  def save_to_yaml
    YAML.dump(
      'secret word' => @secret_word,
      'placeholder' => @placeholder,
      'victory' => @victory,
      'guess count' => @guess_count,
      'guess array' => @guess_array
    )
  end

  #unserialise?


  def file_list
    files = []
    directory = File.expand_path("../../saved",__FILE__)
    puts "dir path: #{directory}"
    all_files = Dir["#{directory}/*"]
    puts "files in dir: #{all_files} end"
    Dir.entries(directory).each do |name|
      if name.match(/\.yaml\z/)
        files << name.gsub(/\.yaml\z/, "")
      end
    end
    files
  end

  def show_file_list
    file_list.each_with_index do |name, index|
      puts display_saved_games((index + 1).to_s, name.to_s)
    end
  end

  def display_saved_games(number,name)
    <<~HEREDOC
    \e[34m[#{number}]\e[0m #{name}
    HEREDOC
  end

  def display_start_choice
    text1 = "Play a new game"
    text2 = "Load a saved game"
    <<~HEREDOC
    \e[34m[#{1}]\e[0m #{text1}
    \e[34m[#{2}]\e[0m #{text2}
    HEREDOC
  end

  def load_saved_file
    puts "Here are the current saved games. Please choose which you'd like to load."
    show_file_list
    puts "enter file name"
    @saved_game = gets.chomp
    file = YAML.safe_load(File.read("../saved/#{@saved_game}.yaml"))
    @secret_word = file['secret word']
     @placeholder = file['placeholder']
      @victory =file['victory']
      @guess_count = file['guess count']
      @guess_array = file['guess array']
      p @guess_array
      p @placeholder
      #puts "player enter your guess"
      #@guess = gets.chomp
  end
end
