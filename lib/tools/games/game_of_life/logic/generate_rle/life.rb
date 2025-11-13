
#!/usr/bin/env ruby

# Copyright (c) 2009 Thomas Robinson <tlrobinson.net>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

require 'optparse'
require 'font'
require 'lifepattern'

class BitmapLifePattern < LifePattern

  def initialize(columns, rows)
    super(nil)

    puts "Generating board of size #{columns}x#{rows}"

    # we get 5 by default. each additional chunk adds 4
    columns = [((columns - 5) / 4.0).ceil, 0].max

    # this is all incredibly fragile

    source = LifePattern.new("template.rle")

    top     = source.copy(225, 0, 40, 45)
    middle  = source.copy(204, 29, 28, 39)
    bottom  = source.copy(0, 205, 90, 88)
    bottom.cut(31,0,51,35)

    topX = 18 + 23 * columns
    topY = 2

    bottomX = 0
    bottomY = 0 + 23 * columns

    template = LifePattern.new()

    template.overlay(top, topX, topY)
    template.overlay(bottom, bottomX, bottomY)

    (0..columns - 1).each do |n|
      middleX = topX - 21 - 23 * n
      middleY = topY + 29 + 23 * n

      template.overlay(middle, middleX, middleY)
    end

    # bunch of ugly code to calculate and store the positions of the dots so we can clear them. don't bother trying to figure it out
    @positions = [[227,18],[240,18],[251,30],[241,42]].map{|p| [p[0] - 225 + topX, p[1] + topY]}
    dx, dy = @positions[3] # the 4th dot, at the bottom of the top section
    (0..columns - 1).each do |n|
      @positions << [dx - 12 - n * 23, dy + 11 + n * 23]
      @positions << [dx - (n + 1) * 23, dy + (n + 1) * 23]
    end
    @positions << [bottomX + 24, bottomY + 34]
    dx, dy = @positions[0] # the first dot, at the top left of the top section
    (0..columns - 1).each do |n|
      n = columns - 1 - n
      @positions << [dx - (n + 1) * 23, dy + (n + 1) * 23]
      @positions << [dx - 12 - n * 23, dy + 11 + n * 23]
    end

    (0..rows - 1).each do |n|
      map = template.duplicate
      overlay(map, 115 * n, 18 * n)
    end

    @height = rows
    @width = columns * 4 + 5
    puts "Actual size #{@height}x#{@width}"
  end

  def clearPixel(col, row)
    offset = (@positions.length - 1 - (row * 5) + col) % @positions.length
    setRect(@positions[offset][0] + 115 * row, @positions[offset][1] + 18 * row, 3, 3, nil)
  end

  def draw(drawing)
    (0..@height - 1).each do |row|
      (0..@width - 1).each do |col|
        if (drawing[row].nil? || !drawing[row][col])
          clearPixel(col, row)
          print(".")
        else
          print("*")
        end
      end
      puts ""
    end
  end
end

width = 100.0
height = 50.0
string = nil
imagePath = nil
drawing = nil

opts = OptionParser.new { |opts|
  opts.banner = "Usage: life [life options] output"
  opts.on("-s", "--string STRING", "") { |str|
    string = str
  }
  opts.on("-i", "--image IMAGE", "") { |img|
    imagePath = img
  }
  opts.on("-w", "--width WIDTH", "") { |w|
    width = w.to_i
  }
  opts.on("-h", "--height HEIGHT", "") { |h|
    height = h.to_i
  }
  opts.parse! ARGV
}

if ARGV.length < 1
  abort "need output path"
end

if string
  f = Font.new("font.txt")
  drawing = f.drawingForString(string)

  height = drawing.length
  width = drawing.inject(0) {|m,o| [m, o ? o.length : 0].max } + 10

elsif imagePath
  require 'rmagick'

  image = Magick::ImageList.new(imagePath)[0]

  maxWidth, maxHeight = (width || 100.0), (height || 50.0)
  # max size: 50 height, 100 width
  if (image.base_rows > maxHeight)
    height = maxHeight
    width = ((1.0 * height * image.base_columns)/image.base_rows).round
    image = image.scale(width, height)
  elsif (image.base_columns > maxWidth)
    width = maxWidth
    height = ((1.0 * width * image.base_rows)/image.base_columns).round
    image = image.scale(width, height)
  end

  puts "Original #{image.base_columns}x#{image.base_rows} => #{height}x#{width}"

  drawing = []
  data = image.export_pixels(0, 0, width, height, "i")

  (0..height - 1).each do |row|
    drawingRow = []
    drawing << drawingRow
    (0..width - 1).each do |column|
      gray = data.shift
      drawingRow << (gray < 128) ? true : nil
    end
  end
end

life = BitmapLifePattern.new(width, height)

if drawing
  life.draw(drawing)
end

life.writeRLE(ARGV[0])
