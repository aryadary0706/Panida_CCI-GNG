extends "entity.gd"

func _ready():
	Name = "Vegan_Tier_1"
	Move_speed = 200
	Eat_duration = 2.0
	Stand_visit = 1
	
func start_attack (tower: Node):
	if tower.has_meta("type") and tower.get_meta("type") == "vegan":
		super.start_attack(tower)
