extends Area2D

@export var effectTime: float = 3.0
@export var slowPercentage: float = 0.7   # 0.7 = 70% slow
@export var cooldown: float = 5.0
@onready var areaColor = $AreaColor

var craversInArea: Array[Craver] = []
var affectedCravers: Array[Craver] = []
var slowOnCooldown: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	areaColor.visible = false
	
	
func _process(delta: float) -> void:
	z_index = Global.EffectLayer
	
	
func _on_body_entered(body: Node) -> void:
	if not self.get_parent().hasPlaced:
		return
	if body is Craver and body not in craversInArea:
		craversInArea.append(body)
		_try_trigger_slow()

func _on_body_exited(body: Node) -> void:
	if body is Craver:
		craversInArea.erase(body)
		

func _try_trigger_slow() -> void:
	if slowOnCooldown:
		return
	
	if craversInArea.is_empty():
		return
	
	# Mulai efek slow
	_apply_slow(craversInArea)
	GlobalFunctions.fade_in(areaColor, 0.5)

	# Jalankan timer effect
	await get_tree().create_timer(effectTime).timeout

	# Restore semua craver yang kena slow
	for c in affectedCravers.duplicate():
		_restore_slow(c)

	GlobalFunctions.fade_out(areaColor, 0.5)

	# Masuk cooldown
	slowOnCooldown = true
	await get_tree().create_timer(cooldown).timeout
	slowOnCooldown = false

	# Setelah cooldown, kalau masih ada craver → trigger lagi
	if not craversInArea.is_empty():
		_try_trigger_slow()

func _apply_slow(targets: Array) -> void:
	SfxPlayer.play_music(preload("res://audio/KenaEfekEs.ogg"))
	for c in targets:
		if not is_instance_valid(c): 
			continue
		if c in affectedCravers: 
			continue
		
		var originalSpeed = c.moveSpeed
		c.moveSpeed *= (1.0 - slowPercentage)
		c.modulate = Color(1.5, 0.5, 0.5, 1)
		affectedCravers.append({"craver": c, "original_speed": originalSpeed})

func _restore_slow(entry) -> void:
	if not entry.has("craver"):
		return
	var c: Craver = entry.craver
	if is_instance_valid(c):
		c.moveSpeed = entry.original_speed
		c.modulate = Color(1,1,1,1)
	affectedCravers.erase(entry)
