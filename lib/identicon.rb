require 'digest'
require 'chunky_png'

# Generates GitHub-like identicons using MD5 hashes
class Identicon
  
	attr_accessor :size, :data, :background
  
	CHARS_REGEX = /(\w)(\w)/

	COLORS = {
		:a =>   [196, 108, 168],
		:b =>   [127, 219, 107],
		:c =>   [83, 89, 215],
		:d =>   [111, 198, 148],
		:e =>   [186, 130, 82],
		:f =>   [113, 66, 197],
		:"0" => [201, 186, 84],
		:"1" => [114, 153, 205],
		:"2" => [141, 108, 204],
		:"3" => [75, 183, 114],
		:"4" => [192, 86, 82],
		:"5" => [199, 115, 209],
		:"6" => [206, 77, 94],
		:"7" => [211, 135, 162],
		:"8" => [71, 194, 197],
		:"9" => [188, 110, 93]
	}
  
	class << self 
		# Generates a identicon using the data:image protocol.
		# Usefull for web applications.
		#
		# === Parameters
		#   data 	      - The data that will be converted to a identicon
		#   size        - (Optional) The image size. Defaults to 420px
		#   background  - (Optional) The background color to be used in a rgb array. 
    #                 Ex: [255, 255, 255]
		def data_url_for(data, size = 420, background = nil)
			img = self.new(data, size)
			img.background = background unless background.nil?
			img.generate_image
			img.to_data_url
		end


		# Generates a identicon and stores it in a file
		# Useful for web applications.
		#
		# === Parameters
		#   data 	      - The data that will be converted to a identicon
		#   path        - The path where the file will be stored
		#   size        - (Optional) The image size. Defaults to 420px
		#   background  - (Optional) The background color to be used in a rgb array. 
    #                 Ex: [255, 255, 255]
    #
    # Returns nothing
		def file_for(data, path, size = 420, background = nil)
			img = self.new(data, size)
			img.background = background unless background.nil?
			img.generate_image
			img.save(path)
		end
	end
  
  
	# Constructs a new Identicon instance
	#
	# === Parameters
	# data 	  - The data that will be converted to a identicon
	# size    - The image size
	def initialize(data, size)
		@hash = Digest::MD5.hexdigest(data.to_s)
		@chars = @hash.scan(CHARS_REGEX)
		@color = [0, 0, 0]
		@size = size
		@pixel_ratio = (size / 6).round
		@image_size = @size - (@pixel_ratio / 1.5).round
		@square_array = Hash.new { |h| h = Hash.new(false) }
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
		pImage = ChunkyPNG::Image.new(@image_size, @image_size, ChunkyPNG::Color::rgb(@background[0], @background[1], @background[2]))
		@image = ChunkyPNG::Image.new(@size, @size, ChunkyPNG::Color::rgb(@background[0], @background[1], @background[2]))
		@square_array.each_key { |lineKey|
			lineValue = @square_array[lineKey]
			lineValue.each_index { |colKey|
				colValue = lineValue[colKey]
				if(colValue)
					pImage.rect(
            colKey * @pixel_ratio, 
            lineKey * @pixel_ratio, 
            (colKey + 1) * @pixel_ratio, 
            (lineKey + 1) * @pixel_ratio, 
            ChunkyPNG::Color::TRANSPARENT, 
            ChunkyPNG::Color.rgb(@color[0], @color[1], @color[2])
          )
				end
			}
		}
		@image.compose!(pImage, @pixel_ratio / 2, @pixel_ratio / 2)
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


	private
	def convert_hash
		chars = @chars.map { |p|
			p[1]
		}
		chars.each_index { |i|
			char = chars[i]
			sqIndex = (i / 3).round
			@square_array[i/3] = [] unless @square_array.member? sqIndex

			if(i % 3 == 0) 
				@square_array[i/3][0] = h_to_b char
				@square_array[i/3][4] = h_to_b char
			elsif(i % 3 == 1) 
				@square_array[i/3][1] = h_to_b char
				@square_array[i/3][3] = h_to_b char
			else
				@square_array[i/3][2] = h_to_b char
			end
		}
		color = :a
		0.upto(5) { color = chars.shift.to_sym }
		@color = COLORS[color]
	end

	def h_to_b(value)
		value.bytes.first % 2 == 0
	end
end