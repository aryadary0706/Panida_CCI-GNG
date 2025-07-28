extends StaticBody2D

var Bullet = preload("res://scenes/towers/red_bullet.tscn")
var BulletDamage = 5
var pathName
var currTargets = []
var curr

func _process(delta: float) -> void:
	if is_instance_valid(curr):
		self.look_at(curr.global_position)
	else:
		for i in get_node("BulletContainer").get_child_count():
			get_node("BulletContainer").get_child(i).queue_free()

func _on_tower_body_entered(body: Node2D) -> void:
	if "entity" in body.name:
		var tempArray = []
		currTargets = get_node("Tower").get_overlapping_bodies()
		print(currTargets)

		# Ambil hanya entity
		for i in currTargets:
			if "entity" in i.name:
				tempArray.append(i)

		var bestTarget = null
		for i in tempArray:
			var entityPath = i.get_parent()
			if bestTarget == null or entityPath.get_progress() > bestTarget.get_progress():
				bestTarget = entityPath

		if bestTarget != null:
			curr = bestTarget
			pathName = bestTarget.get_parent().name

			var tempBullet = Bullet.instantiate()
			tempBullet.pathName = pathName
			tempBullet.bulletDamage = BulletDamage
			get_node("BulletContainer").add_child(tempBullet)
			tempBullet.global_position = $Aim.global_position


func _on_tower_body_exited(body: Node2D) -> void:
	currTargets = get_node("Tower").get_overlapping_bodies()
