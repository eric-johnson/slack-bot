require "slack-ruby-bot"
require "pry"
require "blinkstick"

class PongBot < SlackRubyBot::Bot
  def self.stick
    @stick ||= BlinkStick.find_all.first
  end
  def self.reset_stick; @stick = nil; end

  command "ping" do |client, data, match|
    client.say(text: "pong", channel: data.channel)
binding.pry
  end

  command "blink" do |client, data, match|
    retries = 0
    begin
      input_match = match[:expression].match /#(.+)/
      color = input_match ? Color::RGB.by_hex( input_match[1] ) : Color::RGB.by_name( match[:expression] )
      stick.color = color
      client.say( text: "##{color.hex}", channel: data.channel )
    rescue LIBUSB::ERROR_NO_DEVICE
      reset_stick
      retry if (retries += 1) < 3
    rescue StandardError => e
      client.say( text: [e.class, e.message], channel: data.channel )
    end
  end
end

PongBot.run

