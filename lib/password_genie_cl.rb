#!/usr/bin/env ruby
#password_genie_cl.rb

require 'sqlite3'

class WordBank
	attr_reader :word_bank, :number, :special_chars
	
	def word_bank= (words)
		if words == ""
			puts "you have elected to design a numeric PIN."
		end
		unless words.is_a?(String)
			raise "entry must be letters"
		end
		word_bank= words.split("").to_a
		word_bank.delete(" ")
		unless word_bank.is_a?(Array)
			raise "word bank must contain letters"
		end
		@word_bank= word_bank
	end
	
	def number= (number)
		unless number.is_a?(Integer)
			raise "whole numbers only, please"
		end
		if number<=0
			raise ">= 0 only, please"
		end
		@number= number
	end
	
	def special_chars=(special_chars)
		@special_chars=[".",",","$"]
	end
		
	def initialize(words, number=8)
		self.word_bank= words
		self.number= number
		self.special_chars= special_chars
		@password_ary = []
		@numbers= (0..9).to_a
	end
	
	def add_caps
		@caps_bank = []
		@word_bank.each do |letter|
			@caps_bank << letter.upcase
		end
		@word_bank.concat(@caps_bank)
		@caps_bank
	end
	
	def add_special_chars
		@word_bank.concat(@special_chars)
		@word_bank
	end
	
	def add_numbers
		@word_bank.concat(@numbers)
		@word_bank
	end
	
	def create
		i = @number
		until i == 0
			if !@words.nil?
				if i == 3 && (!(@word_bank & @caps_bank).empty? && (@password_ary & @caps_bank).empty?)
					@password_ary << @caps_bank[rand(0..@caps_bank.size - 1)]
				end
				if i == 2 && (!(@word_bank & @special_chars).empty? && (@password_ary & @special_chars).empty?)
					@password_ary << @special_chars[rand(0..@special_chars.size - 1)]
				end
				if i == 1 && (!(@word_bank & @numbers).empty? && (@password_ary & @numbers).empty?)
					@password_ary << @numbers[rand(0..@numbers.size - 1)]
				end			
			else
				letter = rand(0..word_bank.size - 1)
				@password_ary << word_bank[letter]
				@word_bank.delete_at(letter)		
				@password = @password_ary.join()
	
			end
			i -= 1
		end				
		puts @password
		@password
	end
	
	def save_info(site,username,password=@password)
		begin
			db = SQLite3::Database.open('genie.db')
			puts db.get_first_value "select SQLite_VERSION()"
			db.results_as_hash = true
			site_in = site; username_in = username; pw_in = password
			db.transaction
			db.execute "create table if not exists site_info(Id INTEGER PRIMARY KEY, Site TEXT, Username TEXT, Password TEXT)"
			db_in = db.prepare "insert into site_info(Site, Username, Password) values(:site_in, :username_in, :pw_in)"
			db_in.execute site_in, username_in, pw_in
			db.commit
		rescue SQLite3::Exception => e
			puts "something went wrong: #{e}"
			db.rollback
		ensure
			db_in.close if db_in
			db.close if db
		end
	end

	def find_info(info)
		begin
			db = SQLite3::Database.open('genie.db')
			puts db.get_first_value "select SQLite_VERSION()"
			return "please create a directory first" unless File.exist?('genie.db')
			print_out = db.execute2 "SELECT * FROM site_info WHERE Site= :info OR Username = :info", info
			return "no match" unless print_out != nil
			print_out.each do |line|
				puts "[%5s] %8s | %s" % [line[1], line[2], line[3]]
			end
			puts
		rescue SQLite3::Exception => e
			puts e
		ensure
			db.close if db
		end
	end
	
	def add_or_replace_info(site, username, password, choice)
		begin
			db = SQLite3::Database.open('genie.db')
			return "please set up database by restarting and choosing [1]" unless File.file?('genie.db')
			puts db.get_first_value "select SQLite_VERSION()"
			db.transaction
			if choice == 3
				db.execute2 "CREATE table if not exists site_info(Id INTEGER PRIMARY KEY, Site TEXT, Username TEXT, Password TEXT)" 
				db.execute2 "INSERT into site_info(Site, Password, Username) values(:site, :password, :username)" , site, password, username
			else
				db.execute2 "UPDATE site_info SET Password = :password WHERE Site = :site AND Username = :username" , password, site, username 
			end
			db.commit
			if db.changes != 1
				alter = "changes"
			else
				alter = "change"
			end
			puts "you made #{db.changes} #{alter}."
		rescue SQLite3::Exception => e
			puts e
			db.rollback
		ensure
			db.close if db
		end
	end
end
