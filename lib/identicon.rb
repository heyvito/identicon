require 'digest'
require 'chunky_png'

# Generates GitHub-like identicons using MD5 hashes
class Identicon
  attr_accessor :size, :data, :background

  CHARS_REGEX = /(\w)(\w)/

  COLORS = {
    :"a" =>   [196, 108, 168],
    :"b" =>   [127, 219, 107],
    :"c" =>   [83, 89, 215],
    :"d" =>   [111, 198, 148],
    :"e" =>   [186, 130, 82],
    :"f" =>   [113, 66, 197],
    :"0" =>   [201, 186, 84],
    :"1" =>   [114, 153, 205],
    :"2" =>   [141, 108, 204],
    :"3" =>   [75, 183, 114],
    :"4" =>   [192, 86, 82],
    :"5" =>   [199, 115, 209],
    :"6" =>   [206, 77, 94],
    :"7" =>   [211, 135, 162],
    :"8" =>   [71, 194, 197],
    :"9" =>   [188, 110, 93],
  }

  class << self
    # Generates a identicon using the data:image protocol.
    # Useful for web applications.
    #
    # === Parameters
    #   data          - The data that will be converted to a identicon
    #   size        - (Optional) The image size. Defaults to 420px
    #   background  - (Optional) The background color to be used in a rgb array.
    #                 Ex: [255, 255, 255]
    def data_url_for(data, size = 420, background = nil)
      img = Identicon.new(data, size)
      img.background = background unless background.nil?
      img.generate_image
      img.to_data_url
    end

    # Generates a identicon and stores it in a file
    #
    # === Parameters
    #   data          - The data that will be converted to a identicon
    #   path        - The path where the file will be stored
    #   size        - (Optional) The image size. Defaults to 420px
    #   background  - (Optional) The background color to be used in a rgb array.
    #                 Ex: [255, 255, 255]
    #
    # Returns nothing
    def file_for(data, path, size = 420, background = nil)
      img = Identicon.new(data, size)
      img.background = background unless background.nil?
      img.generate_image
      img.save(path)
    end

    # Generates a identicon and returns the binary data
    #
    # === Parameters
    #   data          - The data that will be converted to a identicon
    #   size        - (Optional) The image size. Defaults to 420px
    #   background  - (Optional) The background color to be used in a rgb array.
    #                 Ex: [255, 255, 255]
    #
    # Returns binary_data
    def blob_for(data, size = 420, background = nil)
      img = Identicon.new(data, size)
      img.background = background unless background.nil?
      img.generate_image
      img.to_blob
    end
  end

  # Constructs a new Identicon instance
  #
  # === Parameters
  # data    - The data that will be converted to a identicon
  # size    - The image size
  def initialize(data, size)
    @hash = Digest::MD5.hexdigest(data.to_s)
    @chars = @hash.scan(CHARS_REGEX)
    @color = COLORS[@hash.chars[11].to_sym]
    @size = size
    @pixel_ratio = (size / 6).round
    @image_size = @size - (@pixel_ratio / 1.5).round
    @square_array = Hash.new { Hash.new(false) }
    @background = [240, 240, 240]
    convert_hash
  end

  def size=(value)
    @size = value
    @pixel_ratio = (value / 5).round
    value
  end

  def data=(value)
    @hash = Digest::MD5.hexdigest(data.to_s)
    @chars = @hash.scan(CHARS_REGEX)
    convert_hash
    value
  end

  # Process the specified data and generates the result
  def generate_image
    png_image = ChunkyPNG::Image.new(@image_size,
                                     @image_size,
                                     ChunkyPNG::Color.rgb(@background[0],
                                                          @background[1],
                                                          @background[2])
                                    )
    @image = ChunkyPNG::Image.new(@size,
                                  @size,
                                  ChunkyPNG::Color.rgb(@background[0],
                                                       @background[1],
                                                       @background[2])
                                 )
    @square_array.each_key do |line_key|
      line_value = @square_array[line_key]
      line_value.each_index do |col_key|
        col_value = line_value[col_key]
        if col_value
          png_image.rect(
            col_key * @pixel_ratio,
            line_key * @pixel_ratio,
            (col_key + 1) * @pixel_ratio,
            (line_key + 1) * @pixel_ratio,
            ChunkyPNG::Color::TRANSPARENT,
            ChunkyPNG::Color.rgb(@color[0], @color[1], @color[2])
          )
        end
      end
    end
    @image.compose!(png_image, @pixel_ratio / 2, @pixel_ratio / 2)
  end

  # Exports the result to a data:image format.
  def to_data_url
    @image.to_data_url
  end

  # Exports the result to a file
  # === Parameters
  # path - Path where the image will be stored
  def save(path)
    @image.save(path)
  end

  # Exports the result in binary format
  def to_blob
    @image.to_blob
  end

  private

  def convert_hash
    chars = @chars.map { |p| p[1] }
    chars.each_index do |i|
      char = chars[i]
      sq_index = (i / 3).round
      @square_array[i / 3] = [] unless @square_array.member? sq_index
      if i % 3 == 0
        @square_array[i / 3][0] = h_to_b char
        @square_array[i / 3][4] = h_to_b char
      elsif i % 3 == 1
        @square_array[i / 3][1] = h_to_b char
        @square_array[i / 3][3] = h_to_b char
      else
        @square_array[i / 3][2] = h_to_b char
      end
    end
  end

  def h_to_b(value)
    value.bytes.first.even?
  end
end
