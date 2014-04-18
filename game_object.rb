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
    @tilesize = window.map.tilesize
    @dir = 4
  end
  #Checks Top right, Top left, Bottom right, and Bottom left corners for collision
  def isValid?(newx,newy)
    not @map.solid?(@x+newx, @y+newy) and
    not @map.solid?(@x+newx+8, @y+newy) and
    not @map.solid?(@x+newx, @y+newy+8) and
    not @map.solid?(@x+newx+8, @y+newy+8)
  end
  def warp(newx, newy)
    @x, @y = newx, newy
  end
  
  def changeDir(dir = @dir)
    #only lets you change direction if you can move in that direction
    if(@dir == Direction::Down)
    return if !isValid?(0, 1)
    elsif(@dir == Direction::Left)
      return if !isValid?(-1, 0)
    elsif(@dir == Direction::Up)
      return if isValid?(0, -1)
    elsif(@dir == Direction::Right)
      return if isValid?(1, 0)
    end
    @dir = dir
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
      @x += @map.width*@tilesize
    elsif(@x > @map.width*@tilesize)
      @x -= @map.width*@tilesize
    end
    if(@y < 0)
      @y += @map.height*@tilesize
    elsif(@y > @map.height*@tilesize)
      @y -= @map.height*@tilesize
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
    player_x/@tilesize == ghost_x/@tilesize && player_y/@tilesize == ghost_y/@tilesize
  end
end