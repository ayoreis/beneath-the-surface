extends TileMapLayer

@onready var parent = get_parent()

func _ready() -> void:
	if not parent.is_node_ready():
		await parent.ready
	for i in range(0, round(parent.CELL_WIDTH), 2):
		if randi_range(0, 1) == 1:
			set_cell(Vector2i(i, -1), 1, Vector2i(0, 0))

func gettree() -> Vector2i:
	var mouse_pos = get_global_mouse_position()
	var map_pos = local_to_map(mouse_pos)
	if get_cell_source_id(map_pos) == 1 or get_cell_source_id(map_pos) == 0:
		return map_pos
	return Vector2i(-1, -1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var tree = gettree()
		if tree != Vector2i(-1, -1):
			var grid_size = parent.GRID_SIZE * 2
			grow(Vector2(grid_size*(tree.x+1), grid_size*(tree.y+1)))

func grow(pos) -> void:
	print(get_parent().get_node("Hub").global_position)
	get_parent().get_node("roots").wobblypath(Vector2i(get_parent().get_node("Hub").position), Vector2i(pos.x-parent.GRID_SIZE,pos.y-parent.GRID_SIZE))
