extends Camera2D

var move_speed = 2.5
var invert_scroll = false

var SCROLL_DIRECTION = -1 if invert_scroll else 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var direction = 0
		if (event.button_index == 5):
			direction = 1
		elif (event.button_index == 4):
			direction = -1
		var movement = move_speed * direction * SCROLL_DIRECTION
		position.y = max(0, movement + position.y)
