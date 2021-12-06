require_relative '../src/csv_to_json'

RSpec.describe 'csv_to_json E2E' do
	it "converts a csv with a single praises into a json of the specified format" do
		input_csv = 'samples/complete/sample_praise_single.csv'
		output_json = 'spec/outputs/sample_praise_single.json'
		expected_json = 'samples/complete/sample_praise_single.json'

		csv_to_json(input_csv, output_json)

		expect(File.read(output_json)).to eq(File.read(expected_json))
	end

	it "converts a csv with an array of multiple praises into a json of the specified format" do
		input_csv = 'samples/complete/sample_praise_array.csv'
		output_json = 'spec/outputs/sample_praise_array.json'
		expected_json = 'samples/complete/sample_praise_array.json'

		csv_to_json(input_csv, output_json)

		expect(File.read(output_json)).to eq(File.read(expected_json))
	end
end