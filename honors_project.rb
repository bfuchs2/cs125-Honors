require_relative 'main.rb'
require_relative 'Map.rb'
require_relative 'game_object.rb'
require_relative 'ghost.rb'
require 'gosu'
include Gosu

window = Game.new(5*40*15/2, 5*30*15/2)
window.show
#ghost_x, ghost_yr