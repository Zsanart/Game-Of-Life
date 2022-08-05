extends Node

var width = 64
var height = 48
var board
#var updated_tiles = {}
var live_cells = {}

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_cells():
	var cells_to_update = {}
	for cell in live_cells.keys():
		for i in range(cell.x-1,cell.x+2):
			for j in range(cell.y-1,cell.y+2):
				cells_to_update[Vector2(i,j)] = 0		
	#print(cells_to_update)			
	#print(live_cells)			
	for cell in cells_to_update.keys():
		#update_cell(cell)
		var cell_status = board.get_cell(cell.x, cell.y)
		var new_status = next_status(cell)
		cells_to_update[cell] = new_status
	for cell in cells_to_update:
		board.set_cell(cell.x, cell.y,cells_to_update[cell])
		if cells_to_update[cell] == 1:
			#print(cell)
			live_cells[cell] = 1
		else:
			live_cells.erase(cell)
		#print("new: ",new_status)
#		if cell_status != new_status:
#			board.set_cell(cell.x, cell.y,new_status)
#			if new_status == 1:
#				print(cell)
#				live_cells[cell] = 1
#			else:
#				live_cells.erase(cell)
#	for cell in updated_tiles:
#		board.set_cell(cell.x, cell.y,updated_tiles[cell])	


func next_status(cell):
	var cell_status = board.get_cell(cell.x, cell.y) # 0 dead, 1 live
	var live_neighbors = live_neighbors(cell)						
	if cell_status == 1 && (live_neighbors < 2 || live_neighbors > 3):
		return 0
	elif cell_status == 0 && live_neighbors == 3:
		return 1
	else:
		return cell_status

#func update_cell(cell):
#	var cell_status = board.get_cell(cell.x, cell.y) # 0 dead, 1 live
#	var live_neighbors = live_neighbors(cell)						
#	if cell_status == 1 && (live_neighbors < 2 || live_neighbors > 3):
#		updated_tiles[cell] = 0
#	elif cell_status == 0 && live_neighbors == 3:
#		updated_tiles[cell] = 1

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

#func _process(delta):
#	if Input.is_action_pressed("mouse_down"):
#		var pos = get_viewport().get_mouse_position()
#		var tile_pos = board.world_to_map(pos)
#		handle_input_logic(tile_pos)
			
func handle_input_logic(event):
	var pos = event.position
	var tile_pos = board.world_to_map(pos)
	#if event.pressed:
		#print(tile_pos, ", ",live_neighbors(tile_pos))
			
	var tile_status = board.get_cell(tile_pos.x, tile_pos.y)
	if tile_status == 0:
		board.set_cell(tile_pos.x, tile_pos.y,1)
		live_cells[tile_pos] = 1
	elif not dragging:
		board.set_cell(tile_pos.x, tile_pos.y,0)
		live_cells.erase(tile_pos)
						
		
#func update_tile(tile_pos):
#	var live_neighbors = 0
#	for i in range(tile_pos.x-1,tile_pos.x+1):
#		for j in range(tile_pos.y-1,tile_pos.y+1):
#			if board.get_cell(i,j) == 1:
#				live_neighbors += 1
#	if live_neighbors < 3 && board.get_cell(tile_pos) == 1:
#		updated_tiles[tile_pos] = 0
#	elif live_neighbors 


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
