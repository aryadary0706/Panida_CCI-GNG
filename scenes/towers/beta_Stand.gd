extends StaticBody2D

@export var BulletDamage: int = 5
@export var range: float = 345

@onready var timer: Timer = $Upgrade/ProgressBar/Timer
@onready var upgrade_bar = $Upgrade/ProgressBar
@onready var collision_shape: CollisionShape2D = $Tower/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_powers()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	upgrade_bar.global_position = self.position + Vector2(-55, -92)
	
func _on_tower_body_entered(body: Node2D) -> void:
	if body.has_method("start_attack"):
		body.start_attack(self)

func _on_tower_body_exited(body: Node2D) -> void:
	if body.has_method("stop_attack"):
		body.stop_attack()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var tower_path = get_tree().get_root().get_node("Main/Towers")
		for t in tower_path.get_children():
			if t != self:
				t.get_node("Upgrade/Upgrade").hide()
		
		var upgrade_panel = get_node("Upgrade/Upgrade")
		upgrade_panel.visible = !upgrade_panel.visible
		upgrade_panel.global_position = self.global_position + Vector2(-572, 81)
		
func _on_range_pressed() -> void:
	range += 30
	collision_shape.shape.radius = range
	
func _on_attack_speed_pressed() -> void:
	pass

func _on_power_pressed() -> void:
	BulletDamage += 2
	
func update_powers():
	$Upgrade/Upgrade/HBoxContainer/AttackSpeed/Label.text = "-"
	$Upgrade/Upgrade/HBoxContainer/Range/Label.text = str(range)
	$Upgrade/Upgrade/HBoxContainer/Power/Label.text = str(BulletDamage)
	collision_shape.shape.radius = range
	
