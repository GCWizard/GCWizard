
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

class Font
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
