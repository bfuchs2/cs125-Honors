require 'rubygems'
require 'gosu'
include Gosu
require_relative 'Map'
require_relative 'GameObject'

class Game < Window
  attr_reader :map
  def initialize
    super 640, 480, false
    super 720, 540, false
    self.caption = "Honors Project"
    @map = Map.new(self, "media/Test Map.txt")
    @background = Image.new(self, "media/Space.png", true)
    @player = Player.new(self, 255, 360, "media/Test Sprite.png")
    @ghost = Ghost.new(self, 180, 180, "media/Test Sprite Enemy.png")
  end

  def draw
    @background.draw 0,0,0
    @map.draw
    @player.draw
    @ghost.draw
  end
  
  def update
    dir = Direction::Still
    dir = Direction::Right if button_down? KbRight
    dir = Direction::Left if button_down? KbLeft
    dir = Direction::Up if button_down? KbUp
    dir = Direction::Down if button_down? KbDown
    @player.update(dir)  
  end
  
end


#  def button_down(id)
#    if id == KbEscape then close end
#  end

window = Game.new
window.show