#!/usr/bin/env ruby

# frozen_string_literal: true

# Extend the string class
class String
  def integer?
    match?(/^\d+$/)
  end
end

# Class representing the game
class Hazarda
  def initialize
    @tries = 0
    @random = rand(1..101)
    @exit = false
  end

  def run
    run_once until @exit
  end

  def run_once
    user_input = input
    if user_input == 'q'
      puts 'Goodbye'
      @exit = true
    elsif user_input.integer?
      game user_input
    else
      puts "Unknown input: #{user_input}"
    end
  end

  private

  def input
    print 'Guess the number (q to quit): '
    gets.chomp
  end

  def game(user_input)
    guess = user_input.to_i

    return unless check_range guess

    check_guess guess
  end

  def check_range(guess)
    if guess.negative? || guess > 100
      puts 'Guess must be between 0 and 100'
      false
    else
      @tries += 1
      true
    end
  end

  def check_guess(guess)
    if guess > @random
      puts 'Try a smaller number'
    elsif guess < @random
      puts 'Try a larger number'
    else
      puts "Correct! You got it in #{@tries} tries! 🎉"
      @exit = true
    end
  end
end

Hazarda.new.run
