extends "entity.gd"

func _ready():
	Name = "kambing"
	Move_speed = 200
	Eat_duration = 3.0
	Stand_visit = 1
	
func start_attack (tower: Node):
	if tower.has_meta("type") and tower.get_meta("type") == "vegan":
		super.start_attack(tower)
