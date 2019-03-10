#!/usr/bin/env ruby
#password_genie.rb

require './password_genie_cl.rb'

go = true

while go
	puts "enter [1] to CREATE a new password\nenter [2] to LOOKUP a password"
	puts "enter [3] to ADD a password\nenter [4] to CHANGE an existing password"
	puts "enter [5] to EXIT"
	
	choice = gets.chomp.to_i
	
	if choice == 1
		puts "you will now design a custom password!"
		print "How long do you want your password to be?: "
		
		number = gets.chomp

		unless number = Integer(number) rescue next
		end
		
		if number == 1
			word_number = "character"
		elsif number == 0
			next
		else
			word_number = "characters"
		end
		puts "your word bank will contain #{number} #{word_number}."
		
		print "please compile your word bank ([Enter] for PIN): "
		words = gets.chomp
		if words == '' || words == ' '
			puts "you have elected to create a custom numeric pin"
		end
		
		x = WordBank.new(words,number)
		unless words == '' || words == ' '
			print 'do you wish to include any capitalized letters from your word bank? [y/n]: '
			cap_char = gets.chomp
			x.add_caps unless cap_char == "n"
			print 'do you wish to include special characters such as "." "," and "$"? [y/n]: '
			special_char = gets.chomp
			x.add_special_chars unless special_char == "n" 
			print "do you wish to include numbers? [y/n]: "
			num_chc = gets.chomp
			x.add_numbers unless num_chc == 'n' 
		end
		if words == '' || words == ' '
			x.add_numbers
		end
		x.create
			
		puts "done.\n\n"
		print "\tto save, please enter 'save': "
		choice = gets.chomp.downcase
		if choice == 'save' || choice == 's' || choice == 'yes' || choice == 'y'
			print "enter site: "
			site = gets.chomp.downcase
			print "enter username: "
			username = gets.chomp.to_s
			x.save_info(site,username)
		end
		
		print "go again? [y/n]: "
		choice = gets.chomp
		unless choice == 'y'
			go = false
		end
		next
	elsif choice == 2
		print "enter the word you want to search for (usually site or username):  "
		word = gets.chomp.to_s
		x = WordBank.new(word)
		x.find_info(word)
		next
	elsif choice == 3 || choice == 4
		if choice == 4
			puts "**MUST supply an EXISTING site and username**"
		end
		print "enter site: "
		site = gets.chomp
		print "enter username: "
		username = gets.chomp
		if site == '' || username == ''
			puts "BOTH site and username must be filled in. Back to the beginning."
			next
		end
		if choice == 4
			print "enter new password: "
		else
			print "enter password: "
		end
		password = gets.chomp
		if password != ''
			x = WordBank.new(site)
			x.add_or_replace_info(site, username, password, choice)
		else
			print "password can't be blank."
			next
		end
		next
	elsif choice == 5
		go = false
	else
		next
	end
	
end
