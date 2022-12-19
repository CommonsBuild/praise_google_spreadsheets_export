require_relative '../src/json_parser'

RSpec.describe JSONParser do
	let(:outputs_folder) { 'spec/outputs/' }
	let(:parser) { JSONParser.new(input_json, output_csv, mode: 'test') }

	def open_and_parse_json(file)
		JSON.parse(File.read(file, :encoding => "UTF-8"))
	end

	context "intitialization" do
		let(:input_json) { 'spec/spec_data/jp_dummy.json' }
		let(:output_csv) { 'spec/spec_data/jp_dummy.csv' }

		# it "knows if it is being called for tests" do
		# 	parser.json_to_csv
		# 	expect(CSV.read(output_csv)).to include("YMo")
		# end

		# it "gets its config from a YAML file" do
		# 	yaml_path = outputs_folder + 'dummy.yml'
		# 	yaml = File.open(yaml_path, 'w') { |f|
		# 		f << "default_server:\n"
		# 		f << "  name: 'My Server'\n"
		# 		f << "default_channel:\n"
		# 		f << "  name: 'My Channel'\n"
		# 		f << "discord_ids: 'spec/spec_data/spec_discord_ids.csv'\n"
		# 	}
		# 	parser = JSONParser.new(input_json, output_csv, config: yaml_path)
		# 	parser.json_to_csv

		# 	expect(File.read(output_csv)).to include('My%20Server')
		# end
	end
	context "discord praises with newlines, etc" do
		testfile = 'single_quant'
		let(:samples_folder) { 'spec/spec_data/' }
		let(:input_json) { samples_folder + testfile + '.json' }
		let(:output_csv) { outputs_folder + testfile + '.csv' }

		it "handles them as expected" do
			expected_csv = samples_folder + testfile + '.csv'
			parser.json_to_csv()

			expect(File.read(output_csv)).to eq(File.read(expected_csv))			
		end
	end

	# context "a discord praise to a single receiver" do
	# 	testfile = 'discord_single_receiver_praise'
	# 	let(:samples_folder) { 'samples/discord/' }
	# 	let(:input_csv) { samples_folder + testfile + '.csv' }
	# 	let(:output_json) { outputs_folder + testfile + '.json' }
	
	# 	it "uses the default_server and channel ids if none is provided" do
	# 		expected_json = samples_folder + testfile + '.json'
	# 		parser.csv_to_json
	# 		output = open_and_parse_json(output_json)[0]

	# 		expect(output).to include('sourceName' => "DISCORD:Right%20Here:ComedyCentral")
	# 	end
	# end
	# context "a discord praise with a user with unknown discord_id" do
	# 	testfile = 'discord_unknown_receiver_praise'
	# 	let(:samples_folder) { 'samples/discord/' }
	# 	let(:input_csv) { samples_folder + testfile + '.csv' }
	# 	let(:output_json) { outputs_folder + testfile + '.json' }
	
	# 	it "converts a csv into json" do
	# 		expected_json = outputs_folder + testfile + '.json'

	# 		parser.csv_to_json

	# 		expect(File.read(output_json)).to eq(File.read(expected_json))
	# 	end
	# end
end