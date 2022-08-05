extends CanvasLayer

signal start_pause
signal step
signal clear

var is_paused = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	if is_paused:
		$StartButton.text = "Pause"
	else:
		$StartButton.text = "Run"
	is_paused = !is_paused	
	emit_signal("start_pause")


func _on_StepButton_pressed():
	emit_signal("step")


func _on_ClearButton_pressed():
	if !is_paused:
		emit_signal("start_pause")
		$StartButton.text = "Run"
		is_paused = true
	emit_signal("clear")
	
	
