require_relative '../src/csv_parser'

RSpec.describe CSVParser do
	context "intitialization" do
		let(:input_csv) { 'spec/spec_data/dummy.csv' }
		let(:output_json) { 'spec/spec_data/dummy.json' }

		it "knows if it is being called for tests" do
			parser = CSVParser.new(input_csv, output_json, mode: 'test')
			parser.csv_to_json
			expect(File.read(output_json)).to match(/ComedyCentral/)
		end

		it "gets its config from a YAML file" do
			yaml_path = 'spec/outputs/dummy.yml'
			yaml = File.open(yaml_path, 'w') { |f|
				f << "default_server:\n"
				f << "  name: 'My Server'\n"
				f << "default_channel:\n"
				f << "  name: 'My Channel'\n"
				f << "discord_ids: 'spec/spec_data/spec_discord_ids.csv'\n"
			}
			parser = CSVParser.new(input_csv, output_json, config: yaml_path)
			parser.csv_to_json

			expect(File.read(output_json)).to include('My Server')
		end
	end

	context "a discord praise to multiple receivers" do
		let(:input_csv) { 'samples/discord/discord_multi_receiver_praise.csv' }
		let(:output_json) { 'spec/outputs/discord_multi_receiver_praise.json' }
		let(:parser) { CSVParser.new(input_csv, output_json, mode: 'test') }
	
		it "converts a csv with an array of multiple praises into a json of the specified format" do
			expected_json = 'samples/discord/discord_multi_receiver_praise.json'

			parser.csv_to_json

			expect(File.read(output_json)).to eq(File.read(expected_json))
		end
	end

	context "a discord praise to a single receiver" do
		let(:input_csv) { 'samples/discord/discord_single_receiver_praise.csv' }
		let(:output_json) { 'spec/outputs/discord_single_receiver_praise.json' }
		let(:parser) { CSVParser.new(input_csv, output_json, mode: 'test') }
	
		it "uses the default_server and channel ids if none is provided" do
			expected_json = 'samples/discord/discord_single_receiver_praise.json'
			parser.csv_to_json

			expect(File.read(output_json)).to eq(File.read(expected_json))
		end
	end
end