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
  attr_reader :WIDTH, :HEIGHT, :TILESIZE
  def initialize(window)
    @rand = Random.new
    #Loads 20x20 pix tileset
    #two @s means it's a static variable
    @TILESET = Image.load_tiles(window, "media/Test Tileset.png", 20, 20, true)
    @TILESIZE = 15
    #Reads map.txt line by line and turns it into tiles
    @HEIGHT = 30
    @WIDTH = 40
  end
  
  def generate(objects)
     @tiles = Array.new(@WIDTH){ |i|
        Array.new(@HEIGHT, Tiles::Space)
      }
     for l in 0..10 #generates horizontal lines randomly
       line = [@rand.rand(@WIDTH), @rand.rand(@HEIGHT), @rand.rand(1..10)] #format [midx, midy, length]
       for mover in line[0]-line[2]/2..line[0]+line[2]/2
         begin
          @tiles[mover][line[1]] = Tiles::Wall
         rescue
         end
       end
     end
     for l in 0..10 #same thing now with vertical lines
       line = [@rand.rand(@WIDTH), @rand.rand(@HEIGHT), @rand.rand(1..10)] #format [midx, midy, length]
       for mover in line[1]-line[2]/2..line[1]+line[2]/2
         @tiles[line[0]][mover] = Tiles::Wall
       end
     end
     for x in 0..@WIDTH-1
       for y in 0..@HEIGHT-1
         if(getSurrounding(x, y).length > 6)
           @tiles[x][y] = Tiles::Wall
         end
       end
     end
     #makes sure there's room for the game objects to spawn
     objects.each do |go|
       @tiles[go.x/@TILESIZE][go.y/@TILESIZE] = Tiles::Space
     end
     @tiles
  end
  
  def getSurrounding(x, y)#returns a list of the coords surrounding (x, y) that can be walked on
    array = Array.new
    if(x < @tiles.length and @tiles[x][y + 1] == Tiles::Space)
      array.push([x, y+1])
    end
    if(x + 1 < @tiles.length and @tiles[x + 1][y + 1] == Tiles::Space)
      array.push([x + 1, y + 1])
    end
    if(x + 1< @tiles.length and @tiles[x + 1][y] == Tiles::Space)
      array.push([x + 1, y])
    end
    if(x + 1< @tiles.length and @tiles[x + 1][y - 1] == Tiles::Space)
      array.push([x + 1, y-1])
    end
    if(x < @tiles.length and @tiles[x][y - 1] == Tiles::Space)
      array.push([x, y -1])
    end
    if(x - 1< @tiles.length and @tiles[x - 1][y - 1] == Tiles::Space)
      array.push([x - 1, y - 1])
    end
    if(x - 1< @tiles.length and @tiles[x - 1][y] == Tiles::Space)
      array.push([x - 1, y])
    end
    if(x - 1< @tiles.length and @tiles[x - 1][y + 1] == Tiles::Space)
      array.push([x - 1, y + 1])
    end
    array
  end

  def draw
    @HEIGHT.times do |y|
      @WIDTH.times do|x|
        tile = @tiles[x][y]
        if tile == Tiles::Wall
          @TILESET[tile].draw(x*@TILESIZE, y*@TILESIZE, 0)
        end
      end
    end
  end

  def solid?(x, y)
    #first, makes sure that values of x and y
    #outside the boundaries of the screen wrap around
    if(!@tiles[x/@TILESIZE])
      x -= @WIDTH*@TILESIZE
    end
    if(!@tiles[x/@TILESIZE][y/@TILESIZE])
      y -= @HEIGHT*@TILESIZE
    end
    #this isn't necessary for x, y values less than 0
    #because ruby let's you access the end of an array with
    #negative numbers
    @tiles[x/@TILESIZE][y/@TILESIZE] == Tiles::Wall
  end
end
