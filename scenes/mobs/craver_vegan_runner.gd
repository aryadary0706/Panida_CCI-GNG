extends "entity.gd"

func _ready():
	Name = "Vegan_Runner"
	Move_speed = 400
	Eat_duration = 2.0
	Stand_visit = 1
	
func start_attack (tower: Node):
	if tower.has_meta("type") and tower.get_meta("type") == "vegan":
		super.start_attack(tower)
