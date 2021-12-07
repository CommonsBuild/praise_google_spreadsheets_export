require_relative './csv_parser'
input_folder = 'data/' 
output_folder = 'data/outputs/' 

testfile = 'discord_praise_dec_1_to_dec_5'

parser = CSVParser.new(
	input_folder + testfile + '.csv', 
	output_folder + testfile + '.json'
)

parser.csv_to_json