#!/usr/bin/env ruby
#password_genie.rb

require './password_genie_cl.rb'

go = true

while go
	puts "enter [1] to CREATE a new password\nenter [2] to LOOKUP a password"
	puts "enter [3] to ADD/CHANGE an already existing password\nenter [4] to EXIT"
	
	choice = gets.chomp.to_i
	
	if choice == 1
		puts "you will now design a custom password!"
		puts "How long do you want your password to be?"
		
		number = gets.chomp.to_i
		unless number.is_a?(Integer)
			puts "#{number} is not an Integer."
			puts "Please make a NUMERIC selection from above."
			next
		end
		
		if number == 1
			word_number = "character"
		else
			word_number = "characters"
		end
		puts "your word bank will contain #{number} #{word_number}."
		
		puts "please compile your word bank:"
		words = gets.chomp
		if words == '' || words == ' '
			next
		end
		
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
	elsif choice == 2
		print "enter the word you want to search for (usually site or username):  "
		word = gets.chomp.to_s
		x = WordBank.new(word)
		puts x.find_info(word)
		next
	elsif choice == 3
		puts "**MUST supply an EXISTING site and username**"
		print "enter site: "
		site = gets.chomp
		print "enter username: "
		username = gets.chomp
		if site == '' || username == ''
			puts "BOTH site and username must be filled in. Back to the beginning."
			next
		end
		print "enter password: "
		password = gets.chomp
		x = WordBank.new(site)
		x.add_or_replace_info(site,username,password)
		next
	elsif choice == 4
		go = false
	else
		next
	end
	
end
