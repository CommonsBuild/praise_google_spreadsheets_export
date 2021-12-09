require_relative '../src/csv_parser'

RSpec.describe CSVParser do
	let(:outputs_folder) { 'spec/outputs/' }
	let(:parser) { CSVParser.new(input_csv, output_json, mode: 'test') }

	context "intitialization" do
		let(:input_csv) { 'spec/spec_data/dummy.csv' }
		let(:output_json) { 'spec/spec_data/dummy.json' }

		it "knows if it is being called for tests" do
			parser.csv_to_json
			expect(File.read(output_json)).to match(/ComedyCentral/)
		end

		it "gets its config from a YAML file" do
			yaml_path = outputs_folder + 'dummy.yml'
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
	context "a discord praise with multiple @ references" do
		testfile = 'spec_csv'
		let(:samples_folder) { 'spec/spec_data/' }
		let(:input_csv) { samples_folder + testfile + '.csv' }
		let(:output_json) { outputs_folder + testfile + '.json' }

		it "converts a csv with an array of multiple praises into a json of the specified format" do
			expected_json = samples_folder + testfile + '.json'

			# parser.csv_to_json(pretty: true)
			parser.csv_to_json

			expect(File.read(output_json)).to eq(File.read(expected_json))			
		end
	end

	context "a discord praise with multiple @ references" do
		testfile = 'discord_praise_array'
		let(:samples_folder) { 'samples/discord/' }
		let(:input_csv) { samples_folder + testfile + '.csv' }
		let(:output_json) { outputs_folder + testfile + '.json' }
	
		it "converts a csv with an array of multiple praises into a json of the specified format" do
			expected_json = samples_folder + testfile + '.json'

			parser.csv_to_json

			expect(File.read(output_json)).to eq(File.read(expected_json))
		end
	end

	context "a discord praise to a single receiver" do
		testfile = 'discord_single_receiver_praise'
		let(:samples_folder) { 'samples/discord/' }
		let(:input_csv) { samples_folder + testfile + '.csv' }
		let(:output_json) { outputs_folder + testfile + '.json' }
	
		it "uses the default_server and channel ids if none is provided" do
			expected_json = samples_folder + testfile + '.json'
			parser.csv_to_json

			expect(File.read(output_json)).to eq(File.read(expected_json))
		end

		it "indents the json if pretty flag is set" do
			expected_json = samples_folder + testfile +'_pretty.json'
			parser.csv_to_json(pretty: true)

			expect(File.read(output_json)).to eq(File.read(expected_json))
		end
	end
	context "a discord praise with a user with unknown discord_id" do
		testfile = 'discord_unknown_receiver_praise'
		let(:samples_folder) { 'samples/discord/' }
		let(:input_csv) { samples_folder + testfile + '.csv' }
		let(:output_json) { outputs_folder + testfile + '.json' }
	
		it "converts a csv into json" do
			expected_json = outputs_folder + testfile + '.json'

			parser.csv_to_json

			expect(File.read(output_json)).to eq(File.read(expected_json))
		end
	end
end