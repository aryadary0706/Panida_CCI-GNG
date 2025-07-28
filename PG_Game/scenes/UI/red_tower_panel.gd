extends Panel

var currTile
@onready var tower = preload("res://scenes/towers/red_missile_tower.tscn")


func _on_gui_input(event: InputEvent) -> void:
	var tempTower = tower.instantiate()
	if event is InputEventMouseButton and event.button_mask == 1:
		add_child(tempTower)
		
		tempTower.process_mode = Node.PROCESS_MODE_DISABLED
	elif event is InputEventMouseMotion and event.button_mask == 1:
		get_child(1).global_position = event.global_position
		
	elif event is InputEventMouseButton and event.button_mask == 0:
		print("Left Button Up")
		get_child(1).queue_free()
		var path = get_tree().get_root().get_node("Main/Towers")
		
		path.add_child(tempTower)
		tempTower.global_position = event.global_position
		#tempTower.get_node("Area").hide()
		tempTower.get_node("Tower/CollisionShape2D").show()
	else:
		if get_child_count() > 1:
			get_child(1).queue_free()
