require 'rubygems'
require 'gosu'
#require_relative 'Sprite'
include Gosu

module Tiles
  Wall = 1
end

class Map
  attr_reader :width, :height, :tilesize
  def initialize(window, filename)
    @@rand = Random.new
    #Loads 20x20 pix tileset
    #two ampersands means it's a static variable
    @@tileset = Image.load_tiles(window, "media/Test Tileset.png", 20, 20, true)
    @@tilesize = 15
    #Reads map.txt line by line and turns it into tiles
    lines = File.readlines(filename).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x] 
        when '#' || rand.integer(10) == 1
            Tiles::Wall
          else
            nil
        end
      end
    end
  end
  
  def getSurrounding(x, y)#returns a list of the coords surrounding (x, y) that can be walked on
    array = []
    if(@tiles[x][y + 1] == Tiles::Wall)
      array.push([x, y+1])
    end
    if(@tiles[x + 1][y + 1] == Tiles::Wall)
      array.push([x + 1, y + 1])
    end
    if(@tiles[x + 1][y] == Tiles::Wall)
      array.push([x + 1, y])
    end
    if(@tiles[x + 1][y - 1] == Tiles::Wall)
      array.push([x + 1, y-1])
    end
    if(@tiles[x][y - 1] == Tiles::Wall)
      array.push([x, y -1])
    end
    if(@tiles[x - 1][y - 1] == Tiles::Wall)
      array.push([x - 1, y - 1])
    end
    if(@tiles[x - 1][y] == Tiles::Wall)
      array.push([x - 1, y])
    end
    if(@tiles[x - 1][y + 1] == Tiles::Wall)
      array.push([x - 1, y + 1])
    end
    array
  end
  
  def draw
    @height.times do |y|
      @width.times do|x|
        tile = @tiles[x][y]
        if tile
          @@tileset[tile].draw(x*@@tilesize, y*@@tilesize, 0)
        end
      end
    end
  end

  def solid?(x, y)
    @tiles[x/@@tilesize][y/@@tilesize]
  end
end

module Direction
  Up = 0
  Right = 1
  Down = 2
  Left = 3
  Still = 4 #for when the object isn't moving
end
class GameObject
  attr_reader :x, :y, :dir
  def initialize(window, x, y, image)
    @@SPEED = 3
    @x, @y = x, y
    @map = window.map
    @tilesize = window.map.tilesize
  end
  #Checks Top right, Top left, Bottom right, and Bottom left corners for collision
  def isValid?(newx,newy)
    not @map.solid?(@x+newx, @y+newy)
  end
  
  def warp(newx, newy)
    @x, @y = newx, newy
  end
  def update(dir = @dir)
    if(dir == Direction::Still)
      dir = @dir
    else
      @dir = dir
    end
    if(dir == Direction::Down)
      @@SPEED.times { if isValid?(0, 1); @y+=1; end}
    elsif(dir == Direction::Left)
      @@SPEED.times { if isValid?(-1, 0); @x-=1; end}
    elsif(dir == Direction::Up)
      @@SPEED.times { if isValid?(0, -1); @y-=1; end}
    elsif(dir == Direction::Right)
      @@SPEED.times { if isValid?(1, 0); @x+=1; end}
    end
    # if vx > 0
      # vx.times { if isValid?(vx+1,vy); @x+=vx; end}
    # end
    # if vx < 0
      # (-vx).times { if isValid?(vx-1,vy); @x+=vx; end}
    # end
    # if vy > 0
      # vy.times { if isValid?(vx,vy-2); @y-=vy; end}
    # end
    # if vy < 0
      # (-vy).times { if isValid?(vx,vy+2); @y-=vy; end}
    # end
  end
end

class Player < GameObject
  def initialize(window, x, y, image)
    super
    @image, @image2, @image3, @image4 = *Image.load_tiles(window, image, 15, 15, false)
  end
  def draw
    @image.draw(@x, @y, 1, 1.0, 1.0)
  end
  def fail?(player_x, player_y, ghost_x, ghost_y)
    player_x == ghost_x && player_y == ghost_y
  end
end

class Ghost < GameObject
  def initialize(window, x, y, image)
    super
    @image, @image2, @image3, @image4 = *Image.load_tiles(window, image, 15, 15, false)
  end
    def draw()
    @image.draw(@x, @y, 1, 1.0, 1.0)
  end
end

class Game < Window
  attr_reader :map
  def initialize
    super 640, 480, false
    super 720, 540, false
    self.caption = "Honors Project"
    @map = Map.new(self, "media/Test Map.txt")
    self.caption = "Honors Project"
    @background = Image.new(self, "media/Space.png", true)
    @player = Player.new(self, 255, 360, "media/Test Sprite.png")
    @ghost = Ghost.new(self, 180, 180, "media/Test Sprite Enemy.png")
  end

  def draw
    @background.draw 0,0,0
    @map.draw
    @player.draw
    @ghost.draw
  end
  
  def update
    dir = Direction::Still
    dir = Direction::Right if button_down? KbRight
    dir = Direction::Left if button_down? KbLeft
    dir = Direction::Up if button_down? KbUp
    dir = Direction::Down if button_down? KbDown
    @player.update(dir)  
  end
  
end


#  def button_down(id)
#    if id == KbEscape then close end
#  end

window = Game.new
window.show
