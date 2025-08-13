extends CharacterBody2D

var target
var speed = 1000
var pathName = ""
var bulletDamage

func _physics_process(delta: float) -> void:
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawn")
	
	for i in range(pathSpawnerNode.get_child_count()):
		var child = pathSpawnerNode.get_child(i)
		if child.name == pathName:
			if child.get_child_count() > 0 and child.get_child(0).get_child_count() > 0:
				target = child.get_child(0).get_child(0).global_position
			break # path ditemukan, hentikan loop
	
	if target != null:
		velocity = global_position.direction_to(target) * speed
		look_at(target)
		move_and_slide()




func _on_area_2d_body_entered(body: Node2D) -> void:
	if "entity" in body.name:
		body.Health -= bulletDamage
		queue_free()
