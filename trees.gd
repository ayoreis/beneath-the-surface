extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0,21,2):
		print(randi_range(0,1))
		if (randi_range(0,1)) == 1:
			set_cell(Vector2i(i,-1),0,Vector2i(0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
