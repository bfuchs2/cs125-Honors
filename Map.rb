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
  def initialize(window, pixelH, pixelW)
    #Loads 20x20 pix tileset
    #two @s means it's a static variable
    @TILESET = Image.load_tiles(window, "media/Test Tileset.png", 20, 20, true)
    @TILESIZE = 15
    #Reads map.txt line by line and turns it into tiles
    @HEIGHT = pixelH/@TILESIZE
    @WIDTH = pixelW/@TILESIZE
     @tiles = Array.new(@WIDTH){ |i|
        Array.new(@HEIGHT, Tiles::Space)
      }
  end
  
  def generate(objects)
    rand = Random.new
     for l in 0..10 #generates horizontal lines randomly
       line = [rand.rand(@WIDTH), rand.rand(@HEIGHT), rand.rand(1..10)] #format [midx, midy, length]
       for mover in line[0]-line[2]/2..line[0]+line[2]/2
         begin
          @tiles[mover][line[1]] = Tiles::Wall
         rescue
         end
       end
     end
     for l in 0..10 #same thing now with vertical lines
       line = [rand.rand(@WIDTH), rand.rand(@HEIGHT), rand.rand(1..10)] #format [midx, midy, length]
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
  
  def getSurrounding(x, y, diag = true)
    #returns a list of the coords surrounding (x, y) that can be walked on
    array = Array.new
    if(x < @tiles.length and @tiles[x][y + 1] == Tiles::Space)
      array.push([x, y+1, Direction::Down])
    end
    if(diag and x + 1 < @tiles.length and @tiles[x + 1][y + 1] == Tiles::Space)
      array.push([x + 1, y + 1])
    end
    if(x + 1< @tiles.length and @tiles[x + 1][y] == Tiles::Space)
      array.push([x + 1, y, Direction::Right])
    end
    if(diag and y > 0 and x + 1< @tiles.length and @tiles[x + 1][y - 1] == Tiles::Space)
      array.push([x + 1, y-1])
    end
    if(y > 0 and x < @tiles.length and @tiles[x][y - 1] == Tiles::Space)
      array.push([x, y -1, Direction::Up])
    end
    if(diag and x > 0 and y > 0 and x - 1< @tiles.length and @tiles[x - 1][y - 1] == Tiles::Space)
      array.push([x - 1, y - 1])
    end
    if(x > 0 and x - 1< @tiles.length and @tiles[x - 1][y] == Tiles::Space)
      array.push([x - 1, y, Direction::Left])
    end
    if(diag and x > 0 and x - 1< @tiles.length and @tiles[x - 1][y + 1] == Tiles::Space)
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
    x, y = x/@TILESIZE, y/@TILESIZE
    if(x >= @WIDTH)
      x -= @WIDTH
    end
    if(y >= @HEIGHT)
      y -= @HEIGHT
    end
    #this isn't necessary for x, y values less than 0
    #because ruby let's you access the end of an array with
    #negative numbers
    @tiles[x][y] == Tiles::Wall
  end
  
  def getrandomtile
    begin 
      x= rand(@WIDTH)
      y = rand(@HEIGHT)
    end until @tiles[x][y] != Tiles::Wall
    return x *@TILESIZE, y*@TILESIZE
  end
end