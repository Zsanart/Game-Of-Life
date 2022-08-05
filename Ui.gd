extends CanvasLayer

signal start_pause
signal step
signal clear
signal speed_changed(speed)

var is_paused = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	if is_paused:
		$HBoxContainer/StartButton.text = "Pause"
	else:
		$HBoxContainer/StartButton.text = "Run"
	is_paused = !is_paused	
	emit_signal("start_pause")


func _on_StepButton_pressed():
	emit_signal("step")


func _on_ClearButton_pressed():
	if !is_paused:
		emit_signal("start_pause")
		$HBoxContainer/StartButton.text = "Run"
		is_paused = true
	emit_signal("clear")
	
	


func _on_SpinBox_value_changed(value):
	emit_signal("speed_changed",$HBoxContainer/SpinBox.value)
