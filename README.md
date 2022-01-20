# teensy_rake

A ruby script for converting the csvs of praise data into json handled by the Commons Stack praise system.

tests are used to validate proper handling of edge cases, and json structures.

## Usage

Download the source csv and reference it within `src/main.rb`
create a csv containing the `discord_ids` with the following headers:
`USERNAME,DISCRIMINATOR,DISCORD_ID,AVATAR`
*note: The discriminator is the 4-digit values included with your username (ie user#1234)*

To get set-up using discord, you can [activate developer mode](https://www.howtogeek.com/714348/how-to-enable-or-disable-developer-mode-on-discord/) which will allow you to get a user's id via right clicking.

If you want to use the API, you will need to setup and register a discord bot. 

Ruby users can try [discordrb](https://github.com/discordrb/discordrb/).

You will also need to enable `Server Members Intent` from within your developer portal

 request the `manage channels` permission from your server admin. 
 https://discord.com/oauth2/authorize?client_id=<your_bot_id>&scope=bot&permissions=16

The api documentation for accessing members can be [found here](https://discord.com/developers/docs/resources/guild)

## testing

tests run via the command `rspec`

If you need to change the output of the json, it is suggested to proceed by first changing the sample output manually.  For example:
`samples/discord/discord_single_receiver_praise_pretty.json`

This will cause a test to fail until you succesfully change the code to produce the expected output.

If you encounter an edge case that is not being parsed correctly, you can add the expected input csv and output json located at `spec/spec_data/spec_csv.csv` and `spec/spec_data/spec_csv.json`, respectively