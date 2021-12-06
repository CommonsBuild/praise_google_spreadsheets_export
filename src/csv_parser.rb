require 'csv'
require 'json'

class CSVParser
	def initialize(input_csv, output_json)
			@input_csv = input_csv
			@output_json = output_json
	end

	def csv_to_json
		result = "[\n"
		CSV.open(@input_csv, "rb:UTF-8", headers: true, header_converters: :symbol) do |file|
			file.each do |line|
				puts(line)
				result += create_json(line)
		 	end
		  result += "\n]"
		end
		File.open(@output_json, "w") { |f|
			f.write result
		}
	end

	def create_json(line)
		"{
			\"giver\": { 
				\"id\": \"#{line[:to].split('#')[1]}\",
				\"username\": \"#{line[:to].split('#')[0]}\",
				\"profileImageURL\": \"\",
				\"platform\": \"DISCORD\"
			},
			\"recipients\": [
				{ 
					\"id\": \"#{line[:from].split('#')[1]}\",
					\"username\": \"#{line[:from].split('#')[0]}\",
					\"profileImageURL\": \"\",
					\"platform\": \"DISCORD\"
				}
			],
			\"praiseReason\": \"#{line[:reason]}\",
			\"source\": {
				\"id\": \"#{line[:source_id]}\",
				\"name\": \"#{line[:source_name]}\",
				\"channelId\": \"#{line[:channel_id]}\",
				\"channelName\": \"#{line[:channel_name]}\",
				\"platform\": \"DISCORD\"
			}
		}, "
	end
end