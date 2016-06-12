require "blinkstick"

# TODO: Think of a better name
class BlinkStickController
  attr_reader :stick, :serial, :num_leds

  RETRIES = 3
  SERIAL_CHANNELS = {
    "BS004835-3.0" => 8,
    "BS005430-3.0" => 2
  }

  def initialize( serial=nil, leds=nil )
    @num_leds = leds
    connect( serial )
  end

  def reconnect; connect( serial ); end

  def connect( serial )
    self.stick = if serial
      BlinkStick.find_by_serial( serial )
    else
      BlinkStick.find_all.first
    end
  end

  def set_color( color )
    tries = 0
    color = parse_color( color )
    begin
      tries += 1
      (0...num_leds).each_with_index { |i| stick.set_color( 0, i, color ) }
    rescue LIBUSB::ERROR_NO_DEVICE
      reconnect
      retry if tries < RETRIES
    end
    color
  end

  def parse_color( string )
    case string
    when /^#(.{3}|.{6})$/
      Color::RGB.by_hex( string )
    else
      Color::RGB.by_name( string )
    end
  end

  private

  def stick=( blinkstick )
    @stick = blinkstick
    @serial = blinkstick.serial
    @num_leds ||= SERIAL_CHANNELS.fetch( serial, 2 )
    stick
  end
end
