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
		@input_json["quantifications"].each_with_index do |quant, idx| 
			@headers.append("quant#{idx+1}Id","quant#{idx+1}Score")
		end
		CSV.open(@output_csv, "w") do |csv|
			csv << @headers
			quant_row = [
				@input_json["_id"],
				@input_json["reason"],
				@input_json["server"],
				@input_json["giver"]["_id"],
				@input_json["giver"]["name"],
				@input_json["receiver"]["_id"],
				@input_json["receiver"]["name"]
			]
			@input_json["quantifications"].each_with_index do |quant, idx| 
				quant_row.append(quant["quantifier"],quant["score"])
			end
			csv << quant_row
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