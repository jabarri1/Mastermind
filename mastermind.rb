require 'colorize'

module Colors
  @@color_choices = ['M', 'B', 'G', 'Y', 'W']
  @@correct_color = '*'.red
  @@correct_both = '*'.light_green
end

class Array
  def array_all?(other)
    dup_array = other.dup
    each{ |a| if i = dup_array.index(a) then dup_array.delete_at(i) end }
    dup_array.empty?
  end
end

class Game < Array
  attr_accessor :role, :attempt

  include Colors

  def initialize
    puts 'Welcome to ' + 'MASTERMIND'.blue.bold + '!!'
    @attempt = 1
  end

  def start_game
    puts 'Please enter what you would like to do:'
    puts 'Mastermind'.blue.bold + ': Type 1'
    puts 'Guesser'.magenta.bold + ': Type 2'
    puts 'Rules'.yellow.bold + ': Type 3'

    @role = gets.chomp.to_i

    if @role == 1
      mastermind
    elsif @role == 2
      guesser
    else
      rules
    end
  end

  def guesser
    computer_generated = [@@color_choices.sample, @@color_choices.sample, @@color_choices.sample, @@color_choices.sample]
    player_guess = []
    total_correct = 0
    partial_correct = 0
    puts computer_generated
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'.light_blue
    puts 'The computer has generated a code for you to guess: X | X | X | X'
    while attempt < 11
      until player_guess == computer_generated do
        if attempt > 10
          puts " "
          puts "Sorry, but you're out of turns :(".red
          puts "The Computers code was: #{computer_generated[0]} | #{computer_generated[1]} | #{computer_generated[2]} | #{computer_generated[3]}"
          puts " "
          break
        end
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~".light_blue
        puts "Guess your 4 letters from these 5 colors: #{@@color_choices[0]} | #{@@color_choices[1]} | #{@@color_choices[2]} | #{@@color_choices[3]} | #{@@color_choices[4]}"
        puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'.light_blue
        player_guess = gets.chomp.upcase.split('')
        if player_guess == computer_generated
          puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'.magenta
          puts "Yay!! You guessed correctly! Congrats".magenta
          puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'.magenta
          exit
        end
        until player_guess.length == 4 do
          puts 'Sorry, it looks like you put in too many letters, or an incorrect one. Please try again!'.red
          player_guess = gets.chomp.upcase.split('')
          while player_guess.any? { |i| %w[A C D E F H I J K L N O P Q R S T U V X Z].include? i } || player_guess.length > 4
            puts 'Sorry, it looks like you put in too many letters, or an incorrect one. Please try again!'.red
            player_guess = gets.chomp.upcase.split('')
          end
        end
        puts " "
        player_guess.each_with_index do |v, i|  
          if v == computer_generated[i]
            total_correct += 1
          end
        end
        partial_correct = computer_generated.difference(player_guess)

        puts '---------------------------'
        puts "Turn ##{@attempt}"
        puts 'Correct letters: ' + ('*'.red * (4 - partial_correct.length))
        puts 'Correct letters & Pos: '+ ("*".green * total_correct)
        puts '---------------------------'
        total_correct = 0
        partial_correct = 0
        @attempt += 1
      end
    end
  end

  def mastermind
    puts 'Hello ' + 'Mastermind'.blue.bold + ". Please input 4 of these in any order you'd like"
    puts "Just type them, one after the other. No spaces. Case doesn't matter."
    puts "#{@@color_choices[0]} | #{@@color_choices[1]} | #{@@color_choices[2]} | #{@@color_choices[3]} | #{@@color_choices[4]}"
    code = gets.chomp.upcase.split('')
    until code.length == 4 do
      puts 'Sorry, it looks like you put in too many letters, or an incorrect one. Please try again!'.red
      code = gets.chomp.upcase.split('')
      while code.any? { |i| %w[A C D E F H I J K L N O P Q R S T U V X Z].include? i } || code.length > 4
        puts 'Sorry, it looks like you put in too many letters, or an incorrect one. Please try again!'.red
        code = gets.chomp.upcase.split('')
      end
    end
    puts "You've made the code: #{code[0]} | #{code[1]} | #{code[2]} | #{code[3]}"
    while attempt < 11
      computer_guess = [@@color_choices.sample, @@color_choices.sample, @@color_choices.sample, @@color_choices.sample]
      puts "The computer has guessed: #{computer_guess[0]} | #{computer_guess[1]} | #{computer_guess[2]} | #{computer_guess[3]}"
      if computer_guess == code
        puts 'The computer guessed right! You are a ' + 'L | O | S | E | R'.yellow
        break
      elsif @attempt == 10
        puts '~~~'.green
        puts 'Congratulations! The computer is dumb and you win!! :D'
        break
      end
      @attempt += 1
      puts '~~~'.red
      sleep 1
    end
  end

  def rules
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'.yellow
    puts 'RULES:'.yellow.bold.underline
    puts 'If you choose to be the ' + 'Mastermind'.blue.bold + ", you will input 4 letters and the
computer will attempt to guess the letters and order you put them in. You can use the same letter multiple times."
    puts '-------------------------------------------------------------------'
    puts 'If you choose to be the' + ' Guesser'.magenta.bold + ", the computer will generate a random
combination of 4 characters for you to then guess."
    puts '-------------------------------------------------------------------'
    puts "Regardless of your choice, the game will allow for 10 guesses from
either you or the computer"
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'.yellow
    start_game
  end
end

game = Game.new

game.start_game
