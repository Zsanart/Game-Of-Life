extends Node

var width = 64
var height = 48
var board
#var updated_tiles = {}
var live_cells = {}
var speed = 0.4

var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	board = get_node("TileMap")
	for i in range(width):
		for j in range(height):
			if board.get_cell(i,j) == 1:
				live_cells[Vector2(i,j)] = 1
	#setup()
	
func setup():
	live_cells = {}
	for i in range(width):
		for j in range(height):
			board.set_cell(i,j,0)


func update_cells():
	var cells_to_update = {}
	for i in range(width):
		for j in range(height):
			var cell_status = board.get_cell(i,j)
			var cell = Vector2(i,j)
			var new_status = next_status(cell)
			cells_to_update[cell] = new_status
	for cell in cells_to_update:
		board.set_cell(cell.x, cell.y,cells_to_update[cell])
		if cells_to_update[cell] == 1:
			#print(cell)
			live_cells[cell] = 1
		else:
			live_cells.erase(cell)


func next_status(cell):
	var cell_status = board.get_cell(cell.x, cell.y) # 0 dead, 1 live
	var live_neighbors = live_neighbors(cell)						
	if cell_status == 1 && (live_neighbors < 2 || live_neighbors > 3):
		return 0
	elif cell_status == 0 && live_neighbors == 3:
		return 1
	else:
		return cell_status


func live_neighbors(cell):
	var cell_status = board.get_cell(cell.x, cell.y)
	var live_neighbors = 0
	for i in range(cell.x-1,cell.x+2):
		for j in range(cell.y-1,cell.y+2):
			#print("(",i," ,", j,")")
			if board.get_cell(i,j) == 1:
				live_neighbors += 1
				
	if	cell_status == 1:
		return live_neighbors - 1
	else:
		return live_neighbors	

func _unhandled_input(event):

	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		print("ok")
		if dragging:
			dragging = false
			return
		handle_input_logic(event)
		dragging = true
	elif event is InputEventMouseMotion and Input.is_action_pressed("mouse_down"):
		if dragging:
			handle_input_logic(event)	

			
func handle_input_logic(event):
	var pos = event.position
	var tile_pos = board.world_to_map(pos)

			
	var tile_status = board.get_cell(tile_pos.x, tile_pos.y)
	if tile_status == 0:
		board.set_cell(tile_pos.x, tile_pos.y,1)
		live_cells[tile_pos] = 1
	elif not dragging:
		board.set_cell(tile_pos.x, tile_pos.y,0)
		live_cells.erase(tile_pos)
						


func _on_Timer_timeout():
	update_cells()
	#updated_tiles.clear()


func _on_start_pause():
	if $Timer.is_stopped():
		$Timer.start()
	else:
		$Timer.stop()


func _on_step():
	update_cells()
	#updated_tiles.clear()


func _on_clear():
	setup()


func _on_speed_changed(new_speed):
	#speed = new_speed
	print("asd")
	$Timer.wait_time = new_speed
