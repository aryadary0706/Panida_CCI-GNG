extends StaticBody2D

var Bullet = preload("res://scenes/towers/red_bullet.tscn")
var BulletDamage = 5
var pathName
var currTargets = []
var curr

var reload = 0
var range = 345

@onready var timer: Timer = $Upgrade/ProgressBar/Timer
var startShooting = false

func _process(delta: float) -> void:
	get_node("Upgrade/ProgressBar").global_position = self.position + Vector2(-55,-92)
	if is_instance_valid(curr):
		self.look_at(curr.global_position)
		if timer.is_stopped():
			timer.start()
	else:
		for i in get_node("BulletContainer").get_child_count():
			get_node("BulletContainer").get_child(i).queue_free()
	update_powers()
	
func Shoot():
	var tempBullet = Bullet.instantiate()
	tempBullet.pathName = pathName
	tempBullet.bulletDamage = BulletDamage
	get_node("BulletContainer").add_child(tempBullet)
	tempBullet.global_position = $Aim.global_position

func _on_tower_body_entered(body: Node2D) -> void:
	if "entity" in body.name:
		var tempArray = []
		currTargets = get_node("Tower").get_overlapping_bodies()
	
		for i in currTargets:
			if "entity" in i.name:
				tempArray.append(i)

		var currTarget = null
		for i in tempArray:
			if currTarget == null:
				currTarget = i.get_node("../")
			else:
				if i.get_parent().get_progress() > currTarget.get_progress():
					currTarget = i.get_node("../")
		
		curr = currTarget
		pathName = currTarget.get_parent().name


func _on_tower_body_exited(body: Node2D) -> void:
	currTargets = get_node("Tower").get_overlapping_bodies()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_mask == 1:
		var towerPath = get_tree().get_root().get_node("Main/Towers")
		
		# Sembunyikan upgrade panel dari tower lain
		for i in range(towerPath.get_child_count()):
			if towerPath.get_child(i).name != self.name:
				towerPath.get_child(i).get_node("Upgrade/Upgrade").hide()
		
		# Toggle panel upgrade milik tower yang diklik
		var upgradePanel = get_node("Upgrade/Upgrade")
		upgradePanel.visible = !upgradePanel.visible
		upgradePanel.global_position = self.global_position + Vector2(-572, 81)


func _on_timer_timeout() -> void:
	Shoot()


func _on_range_pressed() -> void:
	range += 30


func _on_attack_speed_pressed() -> void:
	if reload <= 2:
		reload += 0.1
	timer.wait_time = 3-reload


func _on_power_pressed() -> void:
	BulletDamage += 2

func update_powers():
	get_node("Upgrade/Upgrade/HBoxContainer/AttackSpeed/Label").text = str(3-reload)
	get_node("Upgrade/Upgrade/HBoxContainer/Range/Label").text = str(range)
	get_node("Upgrade/Upgrade/HBoxContainer/Power/Label").text = str(BulletDamage)
	
	get_node("Tower/CollisionShape2D").shape.radius = range
