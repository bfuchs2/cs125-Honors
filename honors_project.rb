require_relative 'main.rb'
require_relative 'Map.rb'
require_relative 'game_object.rb'
require_relative 'ghost.rb'
require_relative 'Goal.rb'
require 'gosu'
include Gosu

#format: Game.new(horizontal_pixels, vertival_pixels) note: both should be multiples of 15
window = Game.new
window.show
#ghost_x, ghost_yr