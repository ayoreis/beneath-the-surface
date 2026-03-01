extends TileMapLayer

var growspeed = 0.1 # change for upgrades or sth 

var startvec = Vector2(50, 50)
var endvec = Vector2(100, 70)

func linethiny(startpos: Vector2i, endpos: Vector2i):
	var dx = abs(endpos.x - startpos.x)
	var dy = abs(endpos.y - startpos.y)
	var sx = 1 if startpos.x < endpos.x else -1
	var sy = 1 if startpos.y < endpos.y else -1
	var err = dx - dy
	var x = startpos.x
	var y = startpos.y
	var cells = []
	while true:
		var pos = Vector2i(x, y)
		cells.append(pos)
		set_cell(pos, 1, Vector2i(0, 0))
		if x == endpos.x and y == endpos.y:
			break
		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			x += sx
		if e2 < dx:
			err += dx
			y += sy
		await get_tree().create_timer(growspeed).timeout
	return cells

func wobblypath(start: Vector2, end: Vector2, waypoints: int = 4):
	var points = [start]
	var fullvec = end - start
	var prev_deviation = 0.0
	
	for i in range(1, waypoints + 1):
		var t = float(i) / (waypoints + 1)
		var base_point = start + fullvec * t
		var perp = fullvec.normalized().orthogonal()
		var maxdev = 20.0
		var deviation = randf_range(-maxdev, maxdev)
		
		deviation = lerp(prev_deviation, deviation, 0.3)
		prev_deviation = deviation
		var wobblepoint = base_point + perp * deviation
		points.append(wobblepoint)
	
	points.append(end)
	
	var all_cells = []
	for i in range(points.size() - 1):
		var cells = await linethiny(Vector2i(points[i]), Vector2i(points[i + 1]))
		all_cells += cells
	for pos in all_cells:
		set_cell(pos, 1, Vector2i(2, 0))
	print("line connected i think")

func _ready():
	#for i in range(8):
	#	wobblypath(Vector2(randi_range(0,180),randi_range(0,320)), Vector2(randi_range(0,180),randi_range(0,320)), randi_range(1,4))
	pass
	
