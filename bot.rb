require "slack-ruby-bot"
require "pry"
require "blinkstick"

class PongBot < SlackRubyBot::Bot
  def self.stick
    @stick ||= BlinkStick.find_all.first
  end

  command "ping" do |client, data, match|
    client.say(text: "pong", channel: data.channel)
binding.pry
  end

  command "blink" do |client, data, match|
    begin
      input_match = match[:expression].match /#(.+)/
      color = input_match ? Color::RGB.by_hex( input_match[1] ) : Color::RGB.by_name( match[:expression] )
      stick.color = color
      client.say( text: "##{color.hex}", channel: data.channel )
    rescue StandardError => e
      client.say( text: e.message, channel: data.channel )
    end
  end
end

PongBot.run

