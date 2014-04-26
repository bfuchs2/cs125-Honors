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
  
  #an implementation of A * 
  #for a better explanation: en.wikipedia.org/wiki/A*_search_algorithm
  def aStar(tx = @player.x/@TILESIZE, ty = @player.y/@TILESIZE, x = @x/@TILESIZE, y = @y/@TILESIZE)
    evald = Array.new #nodes that have already been evaluated
    queue = [Node.new(x, y, nil, 0)]#the last element is the g value
    from = Array.new #nodes that have already been navigated
    until queue.empty?
      current = queue[0]
      queue.each{ |i| current = i  if(i.f < current.f)}
      from.push(current)#move current from 'queue' to 'from'
      queue.delete(current)
      #direction from the second node aka the one after the one the ghost is at
      return from[1][2] if current == [tx, ty]
      @map.getSurrounding(current[0], current[1], false).each{ |n|
        node = Node.toNode(n)
        node.g= current.g + 1
        nodeInEvald = false
        evald.each{ |evNode|
          if(evNode.x == node.x and evNode.y == node.y)
            if(evNode.g <= node.g)
              nodeInEvald = true
              break
            end
          end
        }
        if nodeInEvald
          #TODO continue implementation
        end
      }
    end
  end
  
end

class Node # used by the A* function
  attr_accessor :x, :y, :dir, :g, :h
  def initialize(x, y, dir, g)
    @x, @y, @dir, @g = x, y, dir, g
  end
  def toNode(array) #format: [x, y, dir]
    Node.new(array[0], array[1], dir, nil)
  end
  def f
    @g + @h
  end
  
  def setH(tx, ty)
    @h = (@x - tx).abs + (@y - ty).abs
  end
end