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
