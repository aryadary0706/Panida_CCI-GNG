extends "entity.gd"

func _ready():
	super()
	Name = "babi"
	Move_speed = 200
	Eat_duration = 3.0
	Stand_visit = 1

func _physics_process(delta: float) -> void:
	super(delta)
