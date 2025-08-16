extends "entity.gd"

func _ready():
	Name = "Vegan_Tier_2"
	Move_speed = 300
	Eat_duration = 3.0
	Stand_visit = 2
	
func start_attack (tower: Node):
	if tower.has_meta("type") and tower.get_meta("type") == "vegan":
		super.start_attack(tower)
