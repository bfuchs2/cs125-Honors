require 'gosu'
require_relative 'game_object'


#Dear Michelle,
# All of your code was moved into this file. Everything included under the main update was consolidated into a single
# call to ghost.move(). Your directions were changed to fit into Bernards Direction module and the collision was updated
# so it matched my new collision. The movement kind of seems wonky now, I wish I had asked to see how yours moved before
# if it's wildly different or if you see some code missing somewhere let me now.
# Also, all getter and setter calls were removed and replaced with attr_accessor or attr_reader.
# Please go through the new code to see if I missed something
# Michael

class Ghost < GameObject
  attr_accessor :count
  def initialize(window, x, y, image)
    super
    @player = window.player
    @image, @image2, @image3, @image4 = *Image.load_tiles(window, image, 15, 15, false)
    @count = 0
  end
  def draw
    @image.draw(@x, @y, 1, 1.0, 1.0)
  end
  
  def move
    @count = 0 #makes sure the ghost only moves sometimes
    posdir= @map.getSurrounding(@x/@TILESIZE, @y/@TILESIZE, false)
    posdir.collect!{|i| i.collect{|x| x * 15}}
    tempdir = [@x, @y, Direction::Still*@TILESIZE]
    #decision making happens here, should be more fleshed out
    posdir.each{ |loc|
    if ((loc[0] - @player.x)**2 + (loc[1] - @player.y)**2 < (tempdir[0] - @player.x)**2 + (tempdir[1] - @player.y)**2)
      tempdir = loc    
    end          
    }#end decision making 
    self.changeDir(tempdir[2]/@TILESIZE)
    update
  end
  
end