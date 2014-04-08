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
        case lines[y][x, 1]
          when '#'
            Tiles::Wall
          else
            nil
        end
      end
    end
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
    self.caption = "Honors Project"
    @map = Map.new(self, "media/Test Map.txt")
    @background = Image.new(self, "media/Space.png", true)
  end

  def draw
    @background.draw 0,0,0
    @map.draw
  end
end

window = Game.new
window.show