require 'csv'
require 'json'

class UserLookup
	def initialize(input_csv)
		@input_csv = CSV.open(input_csv, "rb:UTF-8", headers: true, header_converters: :symbol)
	end

	def check_header(header)
		@input_csv.read[header]
	end
	def get_user_from_username(name)
		puts name
		user = {}
		@input_csv.each do |row| 
			puts row[:username]
			puts row[:username] == name
		end

		return user
	end
	def close
		@input_csv.close
	end
end