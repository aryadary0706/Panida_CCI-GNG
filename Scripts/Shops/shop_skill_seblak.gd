extends Area2D

@export var effectTime: float
@export var effectAmount: float
@export var cooldown: float = 5.0
@onready var areaColor = $AreaColor

var craversInArea: Array[Craver] = []
var cooldownTimer: float

func _process(delta: float) -> void:
	if not self.get_parent().hasPlaced:
		return
	if cooldownTimer > 0:
		cooldownTimer -= delta
	elif craversInArea.size() > 0:
		visual_area()
		trigger_slow()
		cooldownTimer = cooldown
		
func _ready() -> void:
	z_as_relative = false
	z_index = 2
	hide()

func _on_body_entered(body: Node) -> void:
	if not self.get_parent().hasPlaced:
		return
	if body is Craver:
		craversInArea.append(body)

func _on_body_exited(body: Node) -> void:
	if body is Craver:
		craversInArea.erase(body)

func trigger_slow():
	for c in craversInArea:
		c.effect_slow(effectTime, effectAmount)
	
func visual_area():
	GlobalFunctions.fade_in(self)
	await get_tree().create_timer(3).timeout
	GlobalFunctions.fade_out(self)
