extends "entity.gd"

@export var BabyScene: PackedScene


func _ready():
	Name = "kanguru"
	Move_speed = 200
	Eat_duration = 3.0
	Stand_visit = 2

func makan_di_stand(delta: float) -> void:
	timer_makan += delta
	
	if timer_makan >= Eat_duration and target_stand:
		Stand_visit -= 1
		print(Name, " selesai makan. Sisa Stand_visit: ", Stand_visit)
		
		if BabyScene:
			var baby = BabyScene.instantiate()
			baby.global_position = global_position + Vector2(32, 0)
			get_parent().add_child(baby)
			print("Bayi kanguru muncul!")
	
	timer_makan = 0.0
	
	if Stand_visit <= 0:
		Game.money += 5
		death()
		return
		
	state = "jalan"
	target_stand = null
	if path_follower:
		path_follower.progress = last_progress
