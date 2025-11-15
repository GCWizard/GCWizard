
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

# parses fonts from http://pentacom.jp/soft/ex/font/

###################################################################################################
#
# RLEPatternFont
#
###################################################################################################

class RLEPatternFont
  def initialize(filename)
    @binary = []

    data = File.read(filename)
    chars = data.split(",")
    chars.each do |string|
      binaryString = string.hex.to_s(2)
      @binary << ("0" * (160 - binaryString.length)) + binaryString
    end
  end

  def drawString(string)
    left = 0
    string.each_byte do |c|
      index = c - 32
      binary = @binary[index]
      width = 0
      row, col = 0, 0

      binary.each_byte do |b|
        if col >= 16
          col = 0
          row += 1
        end

        if b == 49
          yield(left + col, row, true)
          width = col if col > width
        else
          yield(left + col, row, false)
        end

        col += 1
      end

      left += width + 2
    end
  end

  def drawingForString(string)
    drawing = []
    drawString(string) do |x, y, val|
      if (val)
        drawing[y] = [] if drawing[y].nil?
        drawing[y][x] = true
      end
    end
    drawing
  end
end

###################################################################################################
#
# LifePattern
#
###################################################################################################

class LifePattern
  def initialize(filename=nil)
    @map = []
    unless filename.nil?
      loadRLE filename
    end
  end

  attr_accessor :map

  def loadRLE(filename)

    row = 0
    col = 0

    File.new(filename).each do |line|

      if (line.match(/^(#|x |x=)/))
        puts "META: " + line
      else

        line.scan(/[0-9]*[bo\$]|!/) do |run|
          match = run.match(/([0-9]*)([bo\$])/)
          if (match)
            if match[1] != ""
              length = match[1].to_i
            else
              length = 1
            end

            if match[2] == "$"
              row += length
              col = 0
            elsif match[2] == "o"
              length.times {
                set(col, row, true)
                col += 1
              }
            elsif match[2] ==  "b"
              col += length
            else
              puts "OH NO" + match[2]
            end

          elsif run == "!"
            puts "END!"
          else
            puts "unknown:"+run
          end
        end
      end
    end

    puts "rows=#{@map.length}"
  end

  def yieldRLE
    @map.each do |row|
      unless row.nil?
        row.each do |col|
          yield(col ? "o" : "b")
        end
      end
      yield("$\n")
    end
  end

  def writeRLE(filename)
    x = @map.inject(0) {|memo, obj| (obj && obj.length > memo) ? obj.length : memo }
    y = @map.length

    f = File.new(filename, "w")
    f.write("x = #{x}, y = #{y}, rule = B3/S23\n")

    current = nil
    count = 0
    sinceNewline = 0
    yieldRLE do |char|
      if (char == current)
        count += 1
      else
        f.write(count.to_s) if (count > 1)
        f.write(current)    if (count > 0)

        if sinceNewline > 80
          f.write("\n")
          sinceNewline = 0
        end

        current = char
        count = 1
      end
    end

    f.write(count.to_s) if (count > 1)
    f.write(current)    if (count > 0)

    f.write("!")
    f.close

  end

  def get(x, y)
    @map[y] && @map[y][x]
  end

  def set(x, y, value)
    @map[y] = [] if @map[y].nil?
    @map[y][x] = value
  end

  def each
    rowNum = 0
    @map.each do |row|
      colNum = 0
      unless row.nil?
        row.each do |col|
          yield(colNum, rowNum) unless col.nil?
          colNum += 1
        end
      end
      rowNum += 1
    end
  end

  def setRect(x, y, w, h, value)
    (x..x+w-1).each do |col|
      (y..y+h-1).each do |row|
        set(col, row, value)
      end
    end
  end

  def copy(x, y, w, h)
    result = LifePattern.new

    (0..w-1).each do |col|
      (0..h-1).each do |row|
        if get(x + col, y + row)
          result.set(col, row, true)
        end
      end
    end

    result
  end

  def cut(x, y, w, h)
    result = copy(x, y, w, h)
    setRect(x, y, w, h, nil)
    result
  end

  def overlay(map, sx=0, sy=0)
    map.each do |x, y|
      set(x + sx, y + sy, true)
    end
  end

  def duplicate
    result = LifePattern.new
    @map.each do |row|
      if row.nil?
        result.map << nil
      else
        result.map << row.dup
      end
    end
    result
  end
end

###################################################################################################
#
# BitmapLifePattern
#
###################################################################################################

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
  f = RLEPatternFont.new("font.txt")
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
