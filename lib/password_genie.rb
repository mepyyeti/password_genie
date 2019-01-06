#!/usr/bin/env ruby
#password_genie.rb

class WordBank
	attr_reader :word_bank, :number, :special_chars
	
	def word_bank=(words)
		word_bank=words.split("").to_a
		word_bank.delete(" ")
		unless word_bank.is_a?(Array)
			raise "word bank must contain letters"
		end
		@word_bank= word_bank
	end
	
	def number=(number)
		unless number.is_a?(Fixnum)
			raise "whole numbers only, please"
		end
		if number<=0
			raise ">= 0 only, please"
		end
		@number=number
	end
	
	def special_chars=(special_chars)
		@special_chars=[".",",","$"]
	end

	def initialize(words,number=8)
		self.word_bank = words
		self.number = number
		self.special_chars = special_chars
		@password_ary = []
		@numbers= (0..9).to_a
	end
	
	def add_special_chars
		word_bank.concat(@special_chars)
		@word_bank
	end
	
	def add_numbers
		word_bank.concat(@numbers)
		@word_bank
	end
	
	def create
		i = number
		while i != 0
			if i == 2 && (@password_ary.include?([@special_chars]) == false && word_bank.include?(@special_chars))
					@password_ary << @special_chars[rand(1..@special_chars.size)]
			elsif i == 1 && (@password_ary.include?(@numbers) == false && word_bank.include?(@numbers))
					@password_ary << @numbers[rand(1..@numbers.size)]
			end
			letter = rand(1..word_bank.size)
			if letter == nil
				next
			end
			puts "letter: #{word_bank[letter]} and num: #{letter}"
			@password_ary << word_bank[letter]
			word_bank.delete_at(letter)
			i -= 1
		end
		@password = @password_ary.join()
		puts @password
		@password
	end
	
	def save_info(site,username)
		myfile=File.open('site_info.txt','a+') do |f|
			puts "[#{site}] username: #{username} | password: #{@password}"
			f.puts("[#{site}] username: #{username} | password: #{@password}")
		end
	end
end

go = true

while go
	puts "HELLO. You will now design a custom password!"
	puts "How long do you want your password to be?"
	
	number = gets.chomp.to_i
	if number == 1
		word_number = "character"
	else
		word_number = "characters"
	end
	puts "your word bank will contain #{number} #{word_number}."
	
	puts "please compile your word bank:"
	words = gets.chomp
	
	x = WordBank.new(words, number)
	
	puts 'do you wish to include special characters such as "." "," and "$"? [y/n]'
	special_char = gets.chomp
	x.add_special_chars unless special_char == "n" 
	puts "do you wish to include numbers? [y/n]"
	num_chc = gets.chomp
	x.add_numbers unless num_chc == 'n' 
	x.create
	
	puts "done.\n\n"
	puts "\tto save, please enter 'save'"
	choice = gets.chomp.downcase
	if choice == 'save' || choice == 's' || choice == 'yes' || choice == 'y'
		puts "enter site"
		site = gets.chomp.downcase
		puts "enter username"
		username = gets.chomp.to_s
		x.save_info(site,username)
	end
	
	puts "go again? [y/n]"
	choice = gets.chomp
	unless choice == 'y'
		go = false
	end
	next
end
