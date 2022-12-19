require_relative '../src/csv_parser'

RSpec.describe 'E2E parsing' do
	let(:samples_folder) { 'samples/complete/' }
	let(:outputs_folder) { 'spec/outputs/' }
	
	it "converts a csv with a single praises into a json of the specified format" do
		testfile = 'sample_praise_single'
		input_csv = samples_folder + testfile + '.csv'
		output_json = outputs_folder + testfile + '.json'
		expected_json = samples_folder + testfile + '.json'
		parser = CSVParser.new(input_csv, output_json, mode: 'test')

		parser.csv_to_json()
		expect(File.read(output_json)).to eq(File.read(expected_json))
	end

	context "a praise array" do
		let(:testfile) { 'sample_praise_array' }
		let(:input_csv) { samples_folder + testfile + '.csv' }

		it "converts a csv with an array of multiple praises into a json of the specified format" do
			output_json = outputs_folder + testfile + '.json'
			expected_json = samples_folder + testfile + '.json'
			parser = CSVParser.new(input_csv, output_json, mode: 'test')

			parser.csv_to_json()

			expect(File.read(output_json)).to eq(File.read(expected_json))
		end
	end
end