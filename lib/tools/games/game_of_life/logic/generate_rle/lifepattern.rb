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


# reads and writes ".rle" format Game of Life boards, used in Golly

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