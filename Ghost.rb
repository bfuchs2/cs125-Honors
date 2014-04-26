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
    self.changeDir(self.aStar)
    self.changeDir(tempdir[2]/@TILESIZE) if @dir == Direction::Still
    update
  end
  
  #an implementation of A * 
  #for a better explanation: en.wikipedia.org/wiki/A*_search_algorithm
  def aStar(tx = @player.x/@TILESIZE, ty = @player.y/@TILESIZE, x = @x/@TILESIZE, y = @y/@TILESIZE)
    evald = Array.new #nodes that have already been evaluated
    queue = [Node.new(x, y, nil, 0)]#the last element is the g value
    until queue.empty?
      #queue.each{ |q| print q.toArray, "..."}
      #print "\n" #TODO for debugging
      current = queue[0]#finds the node in queue with the lowest f value
      for i in 1..queue.length-1
        current = queue[i] if queue[i].f(tx, ty) < current.f(tx, ty)
      end
      evald.push(current)#move current from 'queue' to 'evald'
      queue.delete(current)
      #direction from the second node aka the one after the one the ghost is at
      if current.x == tx and current.y == y
        return evald[1].dir if evald[1]
        print "the ghost is confused\n" #TODO for debugging
        return Direction::Still 
      end
      @map.getSurrounding(current.x, current.y, false).each{ |n|
        node = Node.toNode(n)
        node.g= current.g + 1
        nodeInEvald = false
        evald.each{ |evNode|
          if(evNode.x == node.x and evNode.y == node.y)
            if(evNode.g > node.g)
              evNode.g = node.g
              evvNode.dir = node.dir
            end
            nodeInEvald = true
            break
          end
        }
        if !nodeInEvald
          queue.push(node)  
        end
      }
    end
    nil
  end
  
end

class Node # used by the A* function
  attr_accessor :x, :y, :dir, :g
  def initialize(x, y, dir, g)
    @x, @y, @dir, @g = x, y, dir, g
  end
  def self.toNode(array) #format: [x, y, dir]
    Node.new(array[0], array[1], array[2], nil)
  end
  def f(tx, ty)
    @g + h(tx, ty)
  end
  def toArray
    [@x, @y, @dir, @g]
  end
  
  def h(tx, ty)
    #calculates the Manhattan distance between (x, y) and (tx, ty)
    (@x - tx).abs + (@y - ty).abs
  end
end