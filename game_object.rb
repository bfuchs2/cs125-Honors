require 'gosu'
include Gosu

module Direction
  Up = 0
  Right = 1
  Down = 2
  Left = 3
  Still = 4 #for when the object isn't moving
end

class GameObject
  attr_reader :x, :y
  attr_accessor :dir
    
  def initialize(window, x, y, image)
    @@SPEED = 3
    @x, @y = x, y
    @map = window.map
    @TILESIZE = window.map.TILESIZE
    @dir = 4
  end
  #Checks Top right, Top left, Bottom right, and Bottom left corners for collision
  def isValid?(newx,newy)
    not @map.solid?(@x+newx, @y+newy) and
    not @map.solid?(@x+newx+8, @y+newy) and
    not @map.solid?(@x+newx, @y+newy+8) and
    not @map.solid?(@x+newx+8, @y+newy+8)
  end
  
  def warp(newCoords)
    @x, @y = newCoords[0], newCoords[1]
  end
  
  def changeDir(dir)
    #only lets you change direction if you can move in that direction
    #returns true if the direction was changed
    if(dir == Direction::Down and !isValid?(0, 1))
      return false
    elsif(dir == Direction::Left and !isValid?(-1, 0))
      return false
    elsif(dir == Direction::Up and !isValid?(0, -1))
      return false
    elsif(dir == Direction::Right and !isValid?(1, 0))
      return false
    end
    @dir = dir
    true
  end
    
  def update
    if(@dir == Direction::Down)
      @@SPEED.times { if isValid?(0, 1); @y+=1; end}
    elsif(@dir == Direction::Left)
      @@SPEED.times { if isValid?(-1, 0); @x-=1; end}
    elsif(@dir == Direction::Up)
      @@SPEED.times { if isValid?(0, -1); @y-=1; end}
    elsif(@dir == Direction::Right)
      @@SPEED.times { if isValid?(1, 0); @x+=1; end}
    end
    if(@x < 0)#makes objects wrap around the map
      @x += @map.WIDTH*@TILESIZE
    elsif(@x > @map.WIDTH*@TILESIZE)
      @x -= @map.WIDTH*@TILESIZE
    end
    if(@y < 0)
      @y += @map.HEIGHT*@TILESIZE
    elsif(@y > @map.HEIGHT*@TILESIZE)
      @y -= @map.HEIGHT*@TILESIZE
    end
  end
end

class Player < GameObject
  def initialize(window, x, y, image)
    super
    @image, @image2, @image3, @image4 = *Image.load_tiles(window, image, 15, 15, false)
  end
  def draw()
    @image.draw(@x, @y, 1, 1.0, 1.0)
  end
  def fail?(player_x, player_y, ghost_x, ghost_y)
    player_x/@TILESIZE == ghost_x/@TILESIZE && player_y/@TILESIZE == ghost_y/@TILESIZE
  end
end