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
var cell_data = {}  # Vector2i -> {chance, color}

func _ready() -> void:
	var pos = Vector2i(randi() % tiles_x, randi() % tiles_y)
	place_cell(pos, 1.0, Color(1, 0, 0, 1))
	notify_runtime_tile_data_update()

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return true

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if cell_data.has(coords):
		tile_data.modulate = cell_data[coords]["color"]
	else:
		tile_data.modulate = Color(0, 0, 0, 1)

func grow(cells, pos):
	var coords_map = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	
	if target_point != Vector2i(-1, -1):
		coords_map.sort_custom(func(a, b):
			var da = (target_point - (pos + a)).length_squared()
			var db = (target_point - (pos + b)).length_squared()
			return da < db
		)
	else:
		return
	
	for cell_offset in coords_map:
		var new_pos = cell_offset + pos
		if new_pos.y < CELL_OFFSET or new_pos.y > tiles_y:
			continue
		if new_pos.x > tiles_x or new_pos.x < 0:
			continue
		var parent_color = cell_data[pos]["color"]
		if cell_data.has(new_pos):
			cell_data[new_pos]["chance"] = min(1.0, cell_data[new_pos]["chance"] + 0.05)
		else:
			# Bias: new cells toward target get higher starting chance
			var start_chance = 0.05
			if target_point != Vector2i(-1, -1):
				var dist_current = (target_point - pos).length_squared()
				var dist_new = (target_point - new_pos).length_squared()
				if dist_new < dist_current:
					start_chance = 0.8
			var new_color = Color(
				clamp(parent_color.r + randf_range(-0.07, 0.07), 0.0, 1.0),
				clamp(parent_color.g + randf_range(-0.07, 0.07), 0.0, 1.0),
				clamp(parent_color.b + randf_range(-0.07, 0.07), 0.0, 1.0),
				1.0
			)
			place_cell(new_pos, start_chance, new_color)
	notify_runtime_tile_data_update()

func place_cell(pos: Vector2i, chance: float, color: Color):
	set_cell(pos, 1, Vector2i(randi() % 2, randi() % 2))
	cell_data[pos] = {"chance": chance, "color": color}
	if target_point == pos:
		target_point = Vector2i(-1, -1)

func _process(delta: float) -> void:
	last_change_time += delta
	if last_change_time > UPDATE_INTERVAL:
		last_change_time -= UPDATE_INTERVAL
		if target_point == Vector2i(-1, -1):
			return
		for coords in cell_data.keys():
			var chance = cell_data[coords]["chance"]
			if chance > randf():
				grow(cell_data.keys(), coords)

func _input(event: InputEvent) -> void:
	if paused:
		return
	if event is InputEventMouseButton:
		if event.button_index == 1:
			target_point = Vector2i(int(event.position.x) / TILE_SIZE, int(event.position.y) / TILE_SIZE)
