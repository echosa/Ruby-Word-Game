# frozen_string_literal: true

def show_intro
  puts 'Welcome to Word Guess!'
end

def show_outro
  puts 'Thanks for playing!'
end

def instructions
  puts
  puts 'INSTRUCTIONS'
  puts 'You will be told how many letters the target word has.'
  puts 'You will be told if your guess is correct.'
  puts 'If it is not, you will be told how many letters in your guess are in the target word.'
end

def request_difficulty
  choice = 0
  until (1..4).include? choice
    puts
    puts 'How hard would you like the game to be?'
    puts '1) Easy (words are 3 letters)'
    puts '2) Moderate (words are 4 or 5 letters)'
    puts '3) Hard (words are 6, 7, or 8 letters)'
    puts '4) Extreme (words are more than 8 letters)'
    choice = gets.chomp.to_i
  end
  choice
end

def correct_difficulty?(target_word, difficulty)
  case difficulty
  when 1
    target_word.length == 3
  when 2
    (4..5).include? target_word.length
  when 3
    (6..8).include? target_word.length
  when 4
    target_word.length > 8
  else
    false
  end
end

def load_target_word
  difficulty = request_difficulty
  target_word = ''
  until correct_difficulty?(target_word, difficulty)
    File.open('dictionary.txt', 'r') do |file|
      target_word = file.readlines.sample.downcase.chomp
    end
  end
  target_word
end

def request_player_action
  choice = 0
  until (1..4).include? choice
    puts
    puts 'What would you like to do?'
    puts '1) Play the game'
    puts '2) Read instructions'
    puts '3) Quit'
    choice = gets.chomp.to_i
  end
  choice
end

def take_turn(target_word)
  puts
  puts "Guess the #{target_word.length}-letter word or just press enter to quit:"
  guess = gets.chomp.downcase
  if guess == target_word
    player_wins(target_word)
    true
  elsif guess.empty?
    give_up(target_word)
    true
  elsif guess.length != target_word.length
    puts "That is not a #{target_word.length}-letter word."
  else
    puts "Your guess has #{check_guess(guess, target_word)} correct letters"
  end
end

def play_game(target_word)
  guess = ''
  player_gives_up = false
  player_gives_up = take_turn(target_word) while (guess != target_word) && !player_gives_up
  player_gives_up
end

def check_guess(guess, target_word)
  letters_in_guess = guess.chars.sort.uniq
  letters_in_target_word = target_word.chars.sort.uniq
  correct_letters = letters_in_guess.delete_if { |letter| !letters_in_target_word.include? letter }
  correct_letters.length
end

def give_up(target_word)
  puts "The word was #{target_word}. Thanks for playing!"
end

def player_wins(target_word)
  puts "Correct! The target word was #{target_word}"
end

def run_game_loop
  player_quit = false
  until player_quit
    case request_player_action
    when 1
      play_game(load_target_word)
    when 2
      instructions
    when 3
      player_quit = true
    else
      puts 'That is not a valid option.'
    end
  end
end

def word_game
  show_intro
  run_game_loop
  show_outro
end

word_game
