#!/usr/bin/env ruby
#password_genie_cl.rb

require 'sqlite3'

class WordBank
	attr_reader :word_bank, :number, :special_chars
	
	def word_bank=(words)
		if words == ""
			raise "can't be empty."
		end
		word_bank= words.split("").to_a
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
		self.special_chars = special_chars.to_a
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
		puts "wordbank: #{@word_bank}, special #{@special_chars}"
		i = number
		puts "create"
		until i == 0
			puts " i is #{i}"
			if i == 2 && (@password_ary.include?(@special_chars) == false && @word_bank.include?(@special_chars))
					@password_ary << @special_chars[rand(0..@special_chars.size)]
					puts "1 == 2"
			end
			if i == 1 && (@password_ary.include?(@numbers) == false && @word_bank.include?(@numbers))
					@password_ary << @numbers[rand(0..@numbers.size)]
					puts "i == 1"
			end
			letter = rand(0..word_bank.size)
			@password_ary << word_bank[letter]
			word_bank.delete_at(letter)
			i -= 1
		end
		@password = @password_ary.join()
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
			puts "hello, again."
			puts info
			print_out = db.execute2 "SELECT * FROM site_info WHERE Site= :info_in OR Username = :info", info
			puts "foo"
			return "no match" unless print_out != nil
			puts "bar"
			print_out.each do |line|
				puts "[%5s] %8s | %s" % [line[1], line[2], line[3]]
			end
			puts "boo"
		rescue SQLite3::Exception => e
			puts "foo2"
			puts e
		ensure
			db.close if db
		end
	end
	
	def add_or_replace_info(site, username, password)
		begin
			db = SQLite3::Database.open('genie.db')
			return "please set up database by restarting and choosing [1]" unless File.file?('genie.db')
			puts db.get_first_value "select SQLite_VERSION()"
			db.transaction
			db.execute2 "UPDATE site_info SET Password = :password WHERE Site = :site AND Username = :username", password, site, username 
			db.commit
			puts "you made #{db.changes} changes."
		rescue SQLite3::Exception => e
			puts e
			db.rollback
		ensure
			db.close if db
		end
	end
end
