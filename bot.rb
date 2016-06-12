$LOAD_PATH.unshift( File.dirname(__FILE__) )

require "slack-ruby-bot"
require "pry"
require "blink_stick_controller"

class PongBot < SlackRubyBot::Bot
  def self.stick
    @stick ||= BlinkStickController.new
  end

  command "ping" do |_client, data, _match|
    client.say(text: "pong", channel: data.channel)
  end

  command "pry me a river" do |client, data, _match|
    client.say(text: "Prying...", channel: data.channel)
    binding.pry
    client.say(text: "...Done Prying", channel: data.channel)
  end

  command "blink" do |client, data, match|
    begin
      color = stick.set_color( match[:expression] )
      client.say( text: "##{color.hex}", channel: data.channel )
    rescue StandardError => e
      client.say( text: [e.class, e.message], channel: data.channel )
    end
  end
end

PongBot.run
