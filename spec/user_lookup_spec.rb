require_relative '../src/user_lookup'

RSpec.describe UserLookup do
	let(:ids_file) { 'spec/spec_data/spec_discord_ids.csv'}
	let(:lookup) { UserLookup.new(ids_file) }

	context "intitialization" do
		it "opens a csv and checks for a header" do
			expect(lookup.check_header(:username)).not_to be_empty
			expect(lookup.check_header(:userhaircut)).to be_empty
		end

# 		it "returns a user if found" do
# user = JSON.generate(
#   username: "simondlr",
#   discriminator: 8472,
#   discord_id: 592383914346020864,
#   avatar: ""
# )

# puts user["username"]
# 			expect(lookup.get_user_from_username(user['username'])).to eq(user)
# 		end
	end
end