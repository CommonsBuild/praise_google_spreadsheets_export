require 'csv'
require 'json'

class UserLookup
	def initialize(input_csv)
		@input_csv = CSV.open(input_csv, "rb:UTF-8", headers: true, header_converters: :symbol)
	end

	def check_header(header)
		@input_csv.read[header]
	end

	def close
		@input_csv.close
	end
end