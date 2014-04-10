require 'rubygems'
require 'gosu'

include Gosu

module Tiles
  Wall = 1
end

class Map
  attr_reader :width, :height
  def initialize(window, filename)
    #Loads 20x20 pix tileset
    @tileset = Image.load_tiles(window, "media/Test Tileset.png", 20, 20, true)
    
    #Reads map.txt line by line and turns it into tiles
    lines = File.readlines(filename).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x]
          when '#'
            Tiles::Wall
          else
            nil
        end
      end
    end
  end
  
  def getSurrounding(x, y)#returns a list of the coords surrounding (x, y) that can be walked on
    array = []
    if(@tiles[x][y + 1])
      array.push([x, y+1])
    end
    if(@tiles[x + 1][y + 1])
      array.push([x + 1, y + 1])
    end
    if(@tiles[x + 1][y])
      array.push([x + 1, y])
    end
    if(@tiles[x + 1][y - 1])
      array.push([x + 1, y-1])
    end
    if(@tiles[x][y - 1])
      array.push([x, y -1])
    end
    if(@tiles[x - 1][y - 1])
      array.push([x - 1, y - 1])
    end
    if(@tiles[x - 1][y])
      array.push([x - 1, y])
    end
    if(@tiles[x - 1][y + 1])
      array.push([x - 1, y + 1])
    end
    array
  end
  
  def draw
    @height.times do |y|
      @width.times do|x|
        tile = @tiles[x][y]
        if tile
          @tileset[tile].draw(x*15, y*15, 0)
        end
      end
    end
  end

  def solid?(x, y)
    @tiles[x/15, y/15]
  end
end

class Game < Window
  attr_reader :map
  def initialize
    super 640, 480, false
    @map = Map.new(self, "media/Test Map.txt")
    self.caption = "Honors Project"
    @background = Image.new(self, "media/Space.png", true)
  end

  def draw
    @background.draw 0,0,0
    @map.draw
  end
end

window = Game.new
window.show
