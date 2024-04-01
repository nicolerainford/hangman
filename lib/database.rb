module Database
  def save_game_choice
    Dir.mkdir('../saved') unless Dir.exist?('../saved')
    puts 'Enter name for saved game'
    @save_name = gets.chomp
    file_path = File.expand_path("../saved/#{@save_name}.yaml", __dir__)
    if File.exist?(file_path)
     puts "Game name " + Rainbow("#{@save_name}").cyan + " already exists. Are you sure you want to overwrite the file? (Yes/No)"
     overwrite_choice = gets.chomp.downcase
     until ["n", "y", "yes", "no"].include?(overwrite_choice)
       puts 'Please either type yes or no'
       overwrite_choice = gets.chomp.downcase
     end
       if ["n","no"].include?(overwrite_choice)
         handle_guess
       elsif ["yes","y"].include?(overwrite_choice)
         save_game
       end
      else
        save_game
     end
  end

  def save_game
    filename = "../saved/#{@save_name}.yaml"
    File.open(filename, 'w') do |file|
      file.write save_to_yaml
    end
    puts "Your game " + Rainbow("#{@save_name}").crimson + " has been saved. Thanks for playing!"
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

  def file_list
    files = []
    directory = File.expand_path('../saved', __dir__)
    all_files = Dir["#{directory}/*"]
    Dir.entries(directory).each do |name|
      files << name.gsub(/\.yaml\z/, '') if name.match(/\.yaml\z/)
    end
    files
  end

  def show_file_list
    file_list.each_with_index do |name, index|
      puts display_saved_games((index + 1).to_s, name.to_s)
    end
  end

  def load_saved_file
    puts "Here are the current saved games. Please choose which you'd like to load."
    show_file_list
    puts 'enter file name'
    load_name = gets.chomp.downcase
    file_path = File.expand_path("../saved/#{@load_name}.yaml", __dir__)
    while !File.exist?(file_path)
      puts "Please enter an " + Rainbow("existing").underline + " file name"
      load_name = gets.chomp.downcase
      file = YAML.safe_load(File.read("../saved/#{load_name}.yaml"))
    end

    file = YAML.safe_load(File.read("../saved/#{load_name}.yaml"))
    puts "loading " + Rainbow("#{saved_name}").cyan + " ..."
    @secret_word = file['secret word']
    @placeholder = file['placeholder']
    @victory = file['victory']
    @guess_count = file['guess count']
    @guess_array = file['guess array']
    p @guess_array
    p @placeholder
  end
end
