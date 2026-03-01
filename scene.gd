extends Node2D

const GRID_SIZE = 8
var WIDTH = 0
var HEIGHT = 0
var CELL_WIDTH = 0
var CELL_HEIGHT = 0

func _ready():
	randomize()
	var size = get_viewport().get_visible_rect().size
	WIDTH = size.x
	HEIGHT = size.y
	CELL_WIDTH = WIDTH / GRID_SIZE
	CELL_HEIGHT = HEIGHT / GRID_SIZE
	#print(WIDTH, " - ", HEIGHT)
