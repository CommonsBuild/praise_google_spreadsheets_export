require_relative './csv_parser'
input_folder = './data/'
output_folder = input_folder + 'outputs/'
file = input_folder + 'december.csv'
# file = input_folder + 'discord_praise_start_to_oct_31.csv'
# Dir.glob(input_folder + "*.csv") do |file|
	input_file = file
	output_file = output_folder + File.basename(file).sub("csv", "json")

puts "Parsing #{input_file}"
puts output_file

	parser = CSVParser.new(
		input_file,
		output_file
	)
	parser.csv_to_json(pretty: false)

# end