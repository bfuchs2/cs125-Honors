require 'rubygems'
require 'gosu'
#require_relative 'Main'
#require_relative 'Sprite'
require_relative 'game_object'
include Gosu

module Tiles
  Space = 0
  Wall = 1
end

class Map
  attr_reader :width, :height, :tilesize
  def initialize(window, filename)
    @rand = Random.new(3)
    #Loads 20x20 pix tileset
    #two @s means it's a static variable
    @tileset = Image.load_tiles(window, "media/Test Tileset.png", 20, 20, true)
    @tilesize = 15
    #Reads map.txt line by line and turns it into tiles
    lines = File.readlines(filename).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    generate
  end
  
  def generate
     @tiles = Array.new(@width){ |i|
        Array.new(@height, Tiles::Space)
      }
     for l in 0..@rand.rand(3..10) #generates horizontal lines randomly
       line = [@rand.rand(@width), @rand.rand(@height), @rand.rand(1..10)] #format [midx, midy, length]
       for mover in line[0]-line[2]/2..line[0]+line[2]/2
         @tiles[mover][line[1]] = Tiles::Wall
       end
     end
     for l in 0..@rand.rand(3..10) #same thing now with vertical lines
       line = [@rand.rand(@width), @rand.rand(@height), @rand.rand(1..10)] #format [midx, midy, length]
       for mover in line[1]-line[2]/2..line[1]+line[2]/2
         @tiles[line[0]][mover] = Tiles::Wall
       end
     end
     for x in 0..@width-1
       for y in 0..@height-1
         if(getSurrounding(x, y).length < 2)
           @tiles[x][y] = Tiles::Wall
         end
       end
     end
     @tiles
  end
  
  def getSurrounding(x, y)#returns a list of the coords surrounding (x, y) that can be walked on
    array = Array.new
    if(x < @tiles.length and @tiles[x][y + 1] == Tiles::Wall)
      array.push([x, y+1])
    end
    if(x + 1 < @tiles.length and @tiles[x + 1][y + 1] == Tiles::Wall)
      array.push([x + 1, y + 1])
    end
    if(x + 1< @tiles.length and @tiles[x + 1][y] == Tiles::Wall)
      array.push([x + 1, y])
    end
    if(x + 1< @tiles.length and @tiles[x + 1][y - 1] == Tiles::Wall)
      array.push([x + 1, y-1])
    end
    if(x < @tiles.length and @tiles[x][y - 1] == Tiles::Wall)
      array.push([x, y -1])
    end
    if(x - 1< @tiles.length and @tiles[x - 1][y - 1] == Tiles::Wall)
      array.push([x - 1, y - 1])
    end
    if(x - 1< @tiles.length and @tiles[x - 1][y] == Tiles::Wall)
      array.push([x - 1, y])
    end
    if(x - 1< @tiles.length and @tiles[x - 1][y + 1] == Tiles::Wall)
      array.push([x - 1, y + 1])
    end
    array
  end

  def draw
    @height.times do |y|
      @width.times do|x|
        tile = @tiles[x][y]
        if tile == Tiles::Wall
          @tileset[tile].draw(x*@tilesize, y*@tilesize, 0)
        end
      end
    end
  end

  def solid?(x, y)
    if(!@tiles[x/@tilesize])
      x -= @width*@tilesize
    end
    @tiles[x/@tilesize][y/@tilesize] == Tiles::Wall
  end
end
