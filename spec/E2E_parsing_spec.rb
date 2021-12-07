require_relative '../src/csv_parser'

RSpec.describe 'E2E parsing' do
	it "converts a csv with a single praises into a json of the specified format" do
		input_csv = 'samples/complete/sample_praise_single.csv'
		output_json = 'spec/outputs/sample_praise_single.json'
		expected_json = 'samples/complete/sample_praise_single.json'
		parser = CSVParser.new(input_csv, output_json)
		parser.csv_to_json(pretty: true)

		expect(File.read(output_json)).to eq(File.read(expected_json))
	end

	it "converts a csv with an array of multiple praises into a json of the specified format" do
		input_csv = 'samples/complete/sample_praise_array.csv'
		output_json = 'spec/outputs/sample_praise_array.json'
		expected_json = 'samples/complete/sample_praise_array.json'
		parser = CSVParser.new(input_csv, output_json)

		parser.csv_to_json(pretty: true)

		expect(File.read(output_json)).to eq(File.read(expected_json))
	end
end