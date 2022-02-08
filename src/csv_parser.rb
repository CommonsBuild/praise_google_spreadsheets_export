require 'yaml'
require 'csv'
require 'json'
require 'pry'
require 'time'
require "erb"

class CSVParser
	def initialize(input_csv, output_json, *args)
		@input_csv = CSV.open(input_csv, "rb:UTF-8", headers: true, header_converters: :symbol)
		@input_rows = CSV.read(input_csv, encoding: "UTF-8").count
		@output_json = File.open(output_json, "w")
		
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

	def csv_to_json(pretty: false)
		@output_json << "[\n"
		@input_csv.each_with_index do |line, idx|
			if idx == @input_rows - 2
				@output_json << create_json(line, pretty)
			else				
				@output_json << create_json(line, pretty) + ",\n"
			end
		end	

		@output_json << "\n]"
		@output_json.close
	end

	def create_json(line, pretty)
		json = JSON.pretty_generate(
			createdAt: formatted_date(line[:date]),
			giver: user_struct(line[:from]),
			receiver: user_struct(line[:to]),
			reason: line[:reason].partition(/(f|F)or/)[-1].strip().gsub('"','\"').gsub('\n','\\n'),
			sourceId: source(line)[:source_id],
			sourceName: source(line)[:source_name]
		)
		pretty ? formatted_json(json) : json
	end
	def source_struct(line)
		source = source(line)
		JSON.generate(
		)	 
	end

	def check_for_header(header)
		@input_csv.headers.include?(header)
	end

	def source(line)
		server_id = check_for_header(:source_id) ? line[:source_id] : @CONFIG['default_server']['id']
		server_name = check_for_header(:source_name) ? line[:source_name] : @CONFIG['default_server']['name']
		channel_id = check_for_header(:channel_id) ? line[:channel_id] : @CONFIG['default_channel']['id']
		channel_name = check_for_header(:channel_name) ? line[:channel_name] : @CONFIG['default_channel']['name']
		return { 
			source_id: "DISCORD:#{server_id}:#{channel_id}",
			source_name: "DISCORD:#{url_encoded(server_name,channel_name)}",
		}
	end

	def receivers
		receivers_array = []
		receivers = line[:reason].split("for")[0].split('@')
		receivers.each do |username|
			user = user_struct(username)
			receivers_array.push(user)
		end
	end

	def user_struct(username)
		user = get_user_from_username(username)
		if user[:discriminator]
			username_string = user[:username] + "#" +user[:discriminator]
		else
			username_string = user[:username]
		end

		user =	{
			id: user[:discord_id],
			username: username_string,
			profileImageURL: user[:profileImageURL],
			platform: 'DISCORD'
		}
	end

	def get_user_from_username(username)
		users = CSV.open(@CONFIG['discord_ids'], "rb:UTF-8", headers: true, header_converters: :symbol) if @CONFIG['discord_ids']
		name = username
		discriminator = ''
		if username.match(/#/)
			name = username.split('#')[0]
			discriminator = username.split('#')[1]
		end
		users.each do |row| 
			if row[:username] == name 
				return {username: row[:username] + '#' + row[:discriminator], server_id: row[:server_id], discord_id: row[:discord_id],profileImageURL: row[:avatar]}
			end
		end
		return {username: username, server_id: nil, discord_id: nil,imageurl: nil}
	end

	def formatted_json(json)
		line = JSON.parse(json)
		giver = user_struct(line["giver"]["username"])
		receiver = line["receiver"]
		"	{
		\"createdAt\": \"#{line["createdAt"]}\",
		\"giver\":
			{
				\"id\": \"#{giver[:id]}\",
				\"username\": \"#{giver[:username]}\",
				\"profileImageURL\": \"#{giver[:profileImageURL]}\",
				\"platform\": \"#{giver[:platform]}\"
			},
		\"receiver\":
			{
				\"id\": \"#{receiver["id"]}\",
				\"username\": \"#{receiver["username"]}\",
				\"profileImageURL\": \"#{receiver["profileImageURL"]}\",
				\"platform\": \"#{receiver["platform"]}\"
			},
		\"reason\": \"#{line["reason"]}\",
		\"sourceId\": \"#{line["sourceId"]}\",
		\"sourceName\": \"#{line["sourceName"]}\"
	}"
	end

	def formatted_date(date)
		Time.parse(date)
	end

	def url_encoded(server, channel)
		"#{ERB::Util.url_encode(server)}:#{ERB::Util.url_encode(channel)}"
	end
end