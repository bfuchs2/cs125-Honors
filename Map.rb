require 'rubygems'
require 'gosu'
require_relative 'game_object'
include Gosu

module Tiles
  Wall = 1
end

class Map
  attr_reader :width, :height, :tilesize
  def initialize(window, filename)
    #Loads 20x20 pix tileset
    @tileset = Image.load_tiles(window, "media/Test Tileset.png", 20, 20, true)
    @tilesize = 15
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

  def draw
    @height.times do |y|
      @width.times do|x|
        tile = @tiles[x][y]
        if tile
          @tileset[tile].draw(x*@tilesize, y*@tilesize, 0)
        end
      end
    end
  end

  def solid?(x, y)
    @tiles[x/@tilesize][y/@tilesize]
  end
end