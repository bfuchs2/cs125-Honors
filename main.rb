require 'gosu'
include Gosu

class Game < Window
  attr_reader :map, :player
  def initialize
    super 720, 540, false
    self.caption = "Honors Project"
    @map = Map.new(self)
    @background = Image.new(self, "media/Space.png", true)
    @player = Player.new(self, 255, 360, "media/Test Sprite.png")
    @ghost = Ghost.new(self, 180, 180, "media/Test Sprite Enemy.png")
    @pause = false
    @map.generate([@ghost, @player])
    @text = Image.new(self, "media/TestPause.png", true)
    @gameover = Image.new(self, "media/TestGameOver.png", true)
    @fail = false
    
    def button_down(id)
      if id == KbP
        @pause = !@pause
      end
    end
  end

  def draw
    @background.draw 0,0,0
    @map.draw
    @player.draw
    @ghost.draw
    if @pause then @text.draw 270, 180, 50 end
    if @fail then @gameover.draw 270,180,50 end
  end
  
  def update
    if !@pause and !@fail
    if @player.fail?(@player.x, @player.y, @ghost.x, @ghost.y)
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
    else
      if button_down? KbEscape
        close
      end
    end
  end      
end
