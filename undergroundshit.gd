extends TileMapLayer

@onready var parent = get_parent()


var nutrients = 0

func _ready() -> void:
	if not parent.is_node_ready():
		await parent.ready

func gettree() -> Vector2i:
	var mouse_pos = get_global_mouse_position()
	var map_pos = local_to_map(mouse_pos)
	var hub_pos = get_parent().get_node("Hub").position
	var distance = mouse_pos.distance_squared_to(hub_pos)
	
	if get_cell_source_id(map_pos) == 1 or get_cell_source_id(map_pos) == 0:
		return map_pos
	return Vector2i(-1, -1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var tree = gettree()
		print(tree)
		if tree != Vector2i(-1, -1):
			grow(16*(tree.x+1), event.position, (tree+Vector2i(1,1))*16 - Vector2i(8,8))

func grow(posx, mousepos, treepos) -> void:
	var the_hub = get_parent().get_node("Hub")
	
	var goalpos = Vector2i(treepos.x,treepos.y)
	var new_nutrients = the_hub.nutrients - the_hub.position.distance_to(goalpos) * .1
	
	if not (new_nutrients <= 0):
		the_hub.nutrients = new_nutrients
		get_parent().get_node("roots").wobblypath(the_hub, goalpos,Vector2i(the_hub.position), goalpos)
	else:
		print("YOU ARE BROKE :loll:")
