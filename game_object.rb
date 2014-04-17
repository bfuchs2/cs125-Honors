require 'gosu'
include Gosu

class GameObject
  attr_reader :x, :y
  def initialize(window, x, y, image)
    @x, @y = x, y
    @map = window.map
    @tilesize = window.map.tilesize
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
  def update(vx,vy)
    if vx > 0
      vx.times { if isValid?(vx+1,vy); @x+=vx; end}
    end
    if vx < 0
      (-vx).times { if isValid?(vx-1,vy); @x+=vx; end}
    end
    if vy > 0
      vy.times { if isValid?(vx,vy-2); @y-=vy; end}
    end
    if vy < 0
      (-vy).times { if isValid?(vx,vy+2); @y-=vy; end}
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

class Ghost < GameObject
  def initialize(window, x, y, image)
    super
    @image, @image2, @image3, @image4 = *Image.load_tiles(window, image, 15, 15, false)
  end
    def draw()
    @image.draw(@x, @y, 1, 1.0, 1.0)
  end
end