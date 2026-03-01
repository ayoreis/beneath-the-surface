extends TileMapLayer

@onready var parent = get_parent()


var nutrients = 0

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
			grow(16*(tree.x+1), event.position, tree)

func grow(posx, mousepos, treepos) -> void:
	var goalpos = Vector2i(posx-8+randi_range(-8,8),0)
	get_parent().get_node("roots").wobblypath(get_parent().get_node("Hub"), goalpos,Vector2i(get_parent().get_node("Hub").position), goalpos)
