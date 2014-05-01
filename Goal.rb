require 'gosu'
require_relative 'game_object'

class Goal
  attr_reader :points
  def initialize(window, player, image) 
    @map = window.map
    @image, @image2, @image3, @image4 = *Image.load_tiles(window, image, 15, 15, false)
    @player = player
    @TILESIZE = window.map.TILESIZE
    @points = 0 
    reset
  end
  def reset
    @x, @y= @map.getrandomtile
  end
  def update
    if @x/@TILESIZE == @player.x/@TILESIZE && @y/@TILESIZE == @player.y/@TILESIZE 
      @points += 1
      reset
    end
  end
  def draw
    @image2.draw(@x, @y, 1, 1.0, 1.0)
  end
end
  
