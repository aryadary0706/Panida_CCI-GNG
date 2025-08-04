extends ProgressBar
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.max_value = get_node("Timer").wait_time
	self.value = get_node("Timer").time_left
