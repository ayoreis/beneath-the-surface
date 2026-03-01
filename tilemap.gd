extends TileMapLayer
const CELL_OFFSET = 5
const TILE_SIZE = 4
const WIDTH = 320
const HEIGHT = 300
const UPDATE_INTERVAL = 0.25
var target_point = Vector2i(-1, -1)
var paused = false
var last_change_time = 0
var tiles_x = WIDTH / TILE_SIZE
var tiles_y = HEIGHT / TILE_SIZE
var cell_data = {}
var reached_target = false
var frontier = []  # cells at the growing edge, sorted by distance to target

func _ready() -> void:
	var pos = Vector2i(randi() % tiles_x, randi() % tiles_y)
	place_cell(pos, 1.0, Color(1, 0, 0, 1))
	frontier.append(pos)
	notify_runtime_tile_data_update()

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return true

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if cell_data.has(coords):
		tile_data.modulate = cell_data[coords]["color"]
	else:
		tile_data.modulate = Color(0, 0, 0, 1)

func get_dist(a: Vector2i) -> float:
	return (target_point - a).length()

func grow(pos):
	var neighbors = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	var parent_color = cell_data[pos]["color"]
	var added_any = false

	for offset in neighbors:
		var new_pos = pos + offset
		if new_pos.y < CELL_OFFSET or new_pos.y > tiles_y:
			continue
		if new_pos.x > tiles_x or new_pos.x < 0:
			continue
		if cell_data.has(new_pos):
			continue

		var new_color = Color(
			clamp(parent_color.r + randf_range(-0.07, 0.07), 0.0, 1.0),
			clamp(parent_color.g + randf_range(-0.07, 0.07), 0.0, 1.0),
			clamp(parent_color.b + randf_range(-0.07, 0.07), 0.0, 1.0),
			1.0
		)
		place_cell(new_pos, 1.0, new_color)
		frontier.append(new_pos)
		added_any = true

		if new_pos == target_point:
			reached_target = true
			notify_runtime_tile_data_update()
			return

	# Once a cell has spread, remove it from frontier
	if added_any:
		frontier.erase(pos)

	notify_runtime_tile_data_update()

func place_cell(pos: Vector2i, chance: float, color: Color):
	set_cell(pos, 1, Vector2i(randi() % 2, randi() % 2))
	cell_data[pos] = {"chance": chance, "color": color}

func _process(delta: float) -> void:
	if reached_target or target_point == Vector2i(-1, -1):
		return
	last_change_time += delta
	while last_change_time > UPDATE_INTERVAL:
		last_change_time -= UPDATE_INTERVAL
		if frontier.is_empty():
			return

		# Sort frontier so closest cells to target are first
		frontier.sort_custom(func(a, b): return get_dist(a) < get_dist(b))

		# Only grow from the N closest frontier cells (with randomness)
		var grow_count = max(1, frontier.size() / 3)
		for i in range(min(grow_count, frontier.size())):
			# Small random skip to keep it organic
			if randf() > 0.85:
				continue
			grow(frontier[i])

func _input(event: InputEvent) -> void:
	if paused:
		return
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		target_point = Vector2i(int(event.position.x) / TILE_SIZE, int(event.position.y) / TILE_SIZE)
		reached_target = false
		# Re-sort frontier toward new target
		if not frontier.is_empty():
			frontier.sort_custom(func(a, b): return get_dist(a) < get_dist(b))
			
