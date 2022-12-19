require 'yaml'
require 'csv'
require 'json'
require 'pry'
require 'time'
require "erb"

class JSONParser
	def initialize(input_json, output_csv, *args)
		@input_json = JSON.parse(File.read(input_json))
		# @input_rows = @input_json.count
		# @dummy_json = File.open(input_json.gsub('.json').to_s + '_dummy.json', mode="w")
		@output_csv = output_csv
		@headers = [
			"id", 
			"reason", 
			"server",
			"giverId",
			"giverName",
			"receiverId",
			"receiverName"
		]

		config_file = 'config.yml'
		if args.count > 0
			args = args[0]
			if args[:config]
				config_file = args[:config]
			end
			if args[:mode] == 'test'
				config_file = 'spec/spec_config.yml'
			end
		end
		@CONFIG = YAML.load(File.read(config_file))
	end

	def json_to_csv()
		@input_json.first["quantifications"].each_with_index do |quant, idx| 
			@headers.append("quant#{idx+1}Id","quant#{idx+1}Score")
		end
		
		CSV.open(@output_csv, "w") do |csv|
			csv << @headers
			@input_json.each do |quant_row|
puts quant_row
				row_arr = [
					quant_row["_id"],
					quant_row["reasonRealized"],
					quant_row["sourceName"],
					quant_row["giver"]["_id"],
					quant_row["giver"]["name"],
					quant_row["receiver"]["_id"],
					quant_row["receiver"]["name"]
				]
				quant_row["quantifications"].each_with_index do |quant, idx| 
					row_arr.append(quant["quantifier"],quant["score"])
				end
				csv << row_arr
			end
		end
	end

	def source_struct(line)
		source = source(line)
		JSON.generate(
		)
	end

	def write_headers()
		@input_csv.headers.include?(header)
	end
end