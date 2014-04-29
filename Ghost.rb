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
  attr_accessor :count, :flank
  def initialize(window, x, y, image)
    super
    @player = window.player
    @image, @image2, @image3, @image4 = *Image.load_tiles(window, image, 15, 15, false)
    @count = 0
    @pathAge = 0
    @flank = false
  end
  def draw
    @image.draw(@x, @y, 1, 1.0, 1.0)
  end
  
  def move
    return @count += 1 if @count < @TILESIZE/@@SPEED
    @count = 0
    #posdir= @map.getSurrounding(@x/@TILESIZE, @y/@TILESIZE, false)
    #posdir.collect!{|i| i.collect{|x| x * 15}}
    #tempdir = [@x, @y, Direction::Still*@TILESIZE]
    #decision making happens here, should be more fleshed out
    #posdir.each{ |loc|
    #if ((loc[0] - @player.x)**2 + (loc[1] - @player.y)**2 < (tempdir[0] - @player.x)**2 + (tempdir[1] - @player.y)**2)
    #  tempdir = loc    
    #end          
    #}#end decision making
    tx, ty = @player.x, @player.y
    if flank and @player.dir != Direction::Still
      until(@map.solid?(tx, ty))
        if(@player.dir == Direction::Down)
          ty += 1
        elsif(@player.dir == Direction::Left)
          tx -= 1
        elsif(@player.dir == Direction::Up)
          ty -= 1
        elsif(@player.dir == Direction::Right)
          tx += 1
        end
      end
      if(@player.dir == Direction::Down)
        ty -= 1
      elsif(@player.dir == Direction::Left)
        tx += 1
      elsif(@player.dir == Direction::Up)
        ty += 1
      elsif(@player.dir == Direction::Right)
        tx -= 1
      end
    end #tx and ty have been found
    if @path == nil or @path.length < 15 or @pathAge > 10
      @path = self.aStar(tx/@TILESIZE, ty/@TILESIZE)
      @pathAge = 0
    else
      #to save on computation, rather than rebuilding the whole path, only part of it is rebuilt
      @path.trim #this moves the part of the path near the ghost
      @path = @path.parent #this retracts the part of the path near the player/target
      if @path.h(tx/@TILESIZE, ty/@TILESIZE) > 6
        @path = self.aStar(tx/@TILESIZE, ty/@TILESIZE)  
      else #creates a short path using A* and appends the current path to that
        @pathAge += 1
        toAppend = @path
        @path = self.aStar(tx/@TILESIZE, ty/@TILESIZE, toAppend.x, toAppend.y)
        node = @path
        node = node.parent while node.parent
        node.parent = toAppend
      end
    end
    node = @path
    node = node.parent while node.parent
    self.warp(node.coords.collect{|i| i * @TILESIZE})
  end
  
  #an implementation of A * 
  #for a better explanation: en.wikipedia.org/wiki/A*_search_algorithm
  def aStar(tx = @player.x/@TILESIZE, ty = @player.y/@TILESIZE, x = @x/@TILESIZE, y = @y/@TILESIZE)
    #exit conditions
    if tx > @map.WIDTH or ty > @map.HEIGHT or tx < 0 or ty < 0
      return Node.new(x, y, nil, 0)
    end
    evald = Array.new #nodes that have already been evaluated
    queue = [Node.new(x, y, nil, 0)]#the last element is the g value
    until queue.empty?
      #queue.each{ |q| print q.toArray, "..."}
      #print "\n" #for debugging
      current = queue[0]#finds the node in queue with the lowest f value
      for i in 1..queue.length-1
        current = queue[i] if queue[i].f(tx, ty) < current.f(tx, ty)
      end
      evald.push(current)#move current from 'queue' to 'evald'
      queue.delete(current)
      #direction from the second node aka the one after the one the ghost is at
      if current.x == tx and current.y == ty
        #TODO this may not be the right thing to return
        current.trim
        return current
        #print "the ghost is confused\n" # for debugging
      end
      @map.getSurrounding(current.x, current.y, false).each{ |n|
        node = Node.toNode(n)
        node.g= current.g + 1
        node.parent= current
        nodeInEvald = false
        evald.each{ |evNode|
          if(evNode.coords == node.coords)
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
  attr_accessor :x, :y, :dir, :g, :parent
  def initialize(x, y, dir, g)
    @x, @y, @dir, @g = x, y, dir, g
  end
  def self.toNode(array) #format: [x, y, dir]
    Node.new(array[0], array[1], array[2], nil)
  end
  def f(tx, ty)
    @g + h(tx, ty)
  end
  #returns the second-to-top most node
  def getTop
    return @parent.getTop if @parent
    self
  end
  def trim # removes the last node (which is the node of the space the ghost is occupying)
    if @parent == nil or @parent.parent == nil
      @parent = nil
    else
      @parent.trim
    end
  end
  def coords
    [@x, @y]
  end
  def length
    return 1 + @parent.length if @parent
    1
  end
  def toArray
    [@x, @y, @dir, @g]
  end
  
  def h(tx, ty)
    #calculates the Manhattan distance between (x, y) and (tx, ty)
    (@x - tx).abs + (@y - ty).abs
  end
end