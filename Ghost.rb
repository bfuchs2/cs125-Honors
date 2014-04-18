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
    @image, @image2, @image3, @image4 = *Image.load_tiles(window, image, 15, 15, false)
    @count = 0
  end
  def draw()
    @image.draw(@x, @y, 1, 1.0, 1.0)
  end
  def move()
    if @count != 0
      @count += 1
      if @count == 16
        @count = 0
      end
      if @dir == 0
        update(0, 1) #going up
      elsif @dir == 1
        update(1, 0) #going to the right
      elsif @dir == 2
        @ghost.update(0, -1) #take it back now yall (down)
      elsif @dir == 3
        @ghost.update(-1, 0) #going to the left
      else 
        @ghost.update(0, 0) 
      end
      dir=(dir)
      return
    end
    posdir= Array.new
    if isValid?(@x + 15, @y) && dir !=3
      posdir.push(1)  
    end
    if isValid?(@x-1, @y) && dir != 1
      posdir.push(3)
    end
    if isValid?(@x, @y+15) && dir !=0
      posdir.push(2)
    end
    if isValid?(@x, @y-1) && dir != 2
      posdir.push(0)
    end

    tempdir = posdir.sample
    if tempdir == 1
      update(tempdir) #going to the right
    elsif tempdir == 3
      update(tempdir) #going to the left
    elsif tempdir == 2
      update(tempdir) #take it back now yall (down)
    elsif tempdir == 0
      update(tempdir) #going up
    else 
      update(4) 
    end
    dir=(tempdir)
    if tempdir != dir
      @count += 1
    end
  end
end

class AI
  def initialize
    @@numAI += 1 #keeps track of how many AIs have been created so that each one is different
    
  end
  
  def move(locations)
    return locations[0] #obviously this will need to be more fleshed out
  end
  
end