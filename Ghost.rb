#contains code for the Ghost class for this project
class Ghost
  def initialize(x, y, color, ai = AI.new)
    @x = x
    @y = y
    @color = color
    @ai = ai
  end
  
  def getX
    return @x
  end
  
  def getY
    return @y
  end

  def getColor
    return color
  end
  
  def setColor(color)
    @color = color
  end
  
  def move #returns the new coordinates of the Ghost
    @x, @y =* ai.move(getSurrounding)
    return [@x, @y]
  end
  
  def getSurrounding
    array = [] #Main.getBoard will return true if it's not a wall
    if(Main.getBoard(@x, @y + 1))
      array.push([@x, @y+1])
    end
    if(Main.getBoard(@x + 1, @y + 1))
      array.push([@X + 1, @y + 1])
    end
    if(Main.getBoard(@x +1, @y))
      array.push([@X + 1, @y])
    end
    if(Main.getBoard(@x + 1, @y - 1))
      array.push([@x + 1, @y -1])
    end
    if(Main.getBoard(@x, @y - 1))
      array.push([@x, @y -1])
    end
    if(Main.getBoard(@x -1, @y -1))
      array.push([@x - 1, @y - 1])
    end
    if(Main.getBoard(@x - 1, @y))
      array.push([@x - 1, @y])
    end
    if(Main.getBoard(@x - 1, @y + 1))
      array.push([@x - 1, @y + 1])
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