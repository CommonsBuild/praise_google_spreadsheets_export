require 'yaml'
require 'csv'
require 'json'

class CSVParser
	def initialize(input_csv, output_json, *args)
		@input_csv = CSV.open(input_csv, "rb:UTF-8", headers: true, header_converters: :symbol)
		@output_json = output_json
		
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

	def csv_to_json
		result = "[\n"
		@input_csv.each do |line|
			result += create_json(line)
		end
		result += "\n]"
		File.open(@output_json, "w") { |f|
			f.write result
		}
	end

	def create_json(line)
		source = source(line)
		"{
			\"giver\":
				#{user_struct(line[:to])},
			\"recipients\": [
				#{user_struct(line[:from])}
			],
			\"praiseReason\": \"#{line[:reason].partition(/(f|F)or/)[-1].strip()}\",
			\"source\": {
				\"id\": \"#{source[:server_id]}\",
				\"name\": \"#{source[:server_name]}\",
				\"channelId\": \"#{source[:channel_id]}\",
				\"channelName\": \"#{source[:channel_name]}\",
				\"platform\": \"DISCORD\"
			}
		}, "
	end

	def check_for_header(header)
		@input_csv.read.headers.include?(header)
	end

	def source(line)
		server_id = check_for_header(:source_id) ? line[:source_id] : @CONFIG['default_server']['id']
		server_name = check_for_header(:source_name) ? line[:source_name] : @CONFIG['default_server']['name']
		channel_id = check_for_header(:channel_id) ? line[:channel_id] : @CONFIG['default_channel']['id']
		channel_name = check_for_header(:channel_name) ? line[:channel_name] : @CONFIG['default_channel']['name']
		return { 
			server_id: server_id,
			server_name: server_name,
			channel_id: channel_id,
			channel_name: channel_name
		}
	end

	def recipients
		recipients_array = []
		recipients = line[:reason].split("for")[0].split('@')
		recipients.each do |username|
			user = user_struct(username)
			recipients_array.push
		end
	end

	def user_struct(username)
		user = get_user_from_username(username)
		return "{
					\"id\": \"#{user[:discord_id]}\",
					\"username\": \"#{user[:username]}\",
					\"profileImageURL\": \"#{user[:imageurl]}\",
					\"platform\": \"DISCORD\"
				}"
	end

	def get_user_from_username(username)
		users = CSV.open(@CONFIG['discord_ids'], "rb:UTF-8", headers: true, header_converters: :symbol) if @CONFIG['discord_ids']
		name = username

		server_id = ''
		if username.match(/#/)
			name = username.split('#')[0]
			server_id = username.split('#')[1]
		end
		users.each do |row| 
			if row[:username] == name 
				return row
			end
		end
puts name, " not found"
	end
end