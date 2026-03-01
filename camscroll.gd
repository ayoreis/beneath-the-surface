extends Camera2D

var move_speed = 2
var invert_scroll = false

var anchor = 180 #bottom shit

var surface = true

var SCROLL_DIRECTION = -1 if invert_scroll else 1

var forest_height = -160
var jumpheight = -18

var targetpos = Vector2.ZERO
var larping = false
var smooth_speed = 5

func _ready() -> void:
	print("aboubou")
	pass # Replace with function body.

func _process(delta: float) -> void:
	if larping:
		position = position.lerp(targetpos, smooth_speed * delta)
		
		if global_position.distance_to(targetpos) < 1.0:
			global_position = targetpos
			larping = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index != 5 and event.button_index != 4 or larping:
			return	
			
		var direction = 0
		if (event.button_index == 5):
			direction = 1
		elif (event.button_index == 4):
			direction = -1
		var movement = move_speed * direction * SCROLL_DIRECTION
		
		if !surface and position.y + movement <= jumpheight:
			surface = true
			larping = true
			targetpos.y = forest_height
			
		elif surface and position.y + movement >= forest_height:
			
			larping = true
			targetpos.y = jumpheight
			surface = false
		
	
		position.y = min(anchor, movement + position.y)
		position.y = max(forest_height, movement+position.y)
