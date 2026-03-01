extends Sprite2D

@export var nutrients = 15
var connections

func _ready() -> void:
	
	get_parent().get_node("Timer").timeout.connect(_on_timeout)
	connections = get_parent().get_node("roots").connections
	pass # Replace with function body.


func _on_timeout():
	for i in connections:
		if i[3] == "tree":
			nutrients += 0.1
	
