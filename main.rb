require 'gosu'
include Gosu

class Game < Window
  attr_reader :map, :player, :ghost
  def initialize(pixelW = 720, pixelH = 540)
    super pixelW, pixelH, false
    self.caption = "Honors Project"
    @map = Map.new(self, pixelH, pixelW)
    @background = Image.new(self, "media/Space.png", true)
    @player = Player.new(self, 255, 360, "media/Test Sprite.png")
    @ghost = Ghost.new(self, 180, 180, "media/Test Sprite Enemy.png")
    @smartGhost = Ghost.new(self, 180, 200, "media/Test Sprite Enemy.png")
    @smartGhost.flank = true
    @pause = false
    @map.generate([@ghost, @player, @smartGhost])
    @text = Image.new(self, "media/TestPause.png", true)
    @gameover = Image.new(self, "media/TestGameOver.png", true)
    @fail = false
  end
  
  def reset
    @map = Map.new(self, @map.HEIGHT*@map.TILESIZE, @map.WIDTH*@map.TILESIZE)
    @player = Player.new(self, 255, 360, "media/Test Sprite.png")
    @ghost = Ghost.new(self, 180, 180, "media/Test Sprite Enemy.png")
    @smartGhost = Ghost.new(self, 180, 400, "media/Test Sprite Enemy.png")
    @smartGhost.flank = true
    @pause = false
    @map.generate([@ghost, @player, @smartGhost])
    @fail = false
  end
  
  def button_down(id)
    if id == KbP
      @pause = !@pause
    end
  end

  def draw
    @background.draw 0,0,0
    @map.draw
    @player.draw
    @ghost.draw
    @smartGhost.draw
    if @pause then @text.draw 270, 180, 50 end
    if @fail then @gameover.draw 270,180,50 end
  end
  
  def update
    if !@pause and !@fail
    if @player.fail?(@ghost.x, @ghost.y) or @player.fail?(@smartGhost.x, @smartGhost.y)
      @fail = true
      if button_down? KbEscape then close end
    end
    dir = Direction::Right if button_down? KbRight
    dir = Direction::Left if button_down? KbLeft
    dir = Direction::Up if button_down? KbUp
    dir = Direction::Down if button_down? KbDown
    if(dir)
      @player.changeDir(dir)
    end
    @player.update
    @ghost.move
    @smartGhost.move
    elsif button_down? KbEscape
      close
    elsif @fail and button_down? KbR
      reset
    end
  end      
end
