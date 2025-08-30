extends Area2D

@export var effectTime: float = 3.0
@export var slowPercentage: float = 2   # 0.7 = 70% slow
@export var cooldown: float = 5.0
@onready var areaColor = $AreaColor

var craversInArea: Array[Craver] = []
var affectedCravers: Dictionary = {}   # key: Craver, value: original_speed
var slowOnCooldown: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	hide()
	z_as_relative = false
	z_index = 2

func _on_body_entered(body: Node) -> void:
	if not self.get_parent().hasPlaced:
		return
	if body is Craver and body not in craversInArea:
		craversInArea.append(body)
		_try_trigger_slow()

func _on_body_exited(body: Node) -> void:
	if body is Craver:
		craversInArea.erase(body)
		# kalau craver keluar area → langsung restore speed
		if affectedCravers.has(body):
			_restore_slow(body)

func _try_trigger_slow() -> void:
	if slowOnCooldown:
		return
	
	if craversInArea.is_empty():
		return
	
	# Mulai efek slow
	_apply_slow(craversInArea)
	GlobalFunctions.fade_in(self)

	# Jalankan timer effect
	await get_tree().create_timer(effectTime).timeout

	# Restore semua craver yang kena slow
	for c in affectedCravers.keys().duplicate():
		_restore_slow(c)

	GlobalFunctions.fade_out(self)

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
		# Cegah slow dobel
		if affectedCravers.has(c): 
			continue
		
		var originalSpeed = c.moveSpeed
		c.moveSpeed *= (1.0 - slowPercentage)
		c.modulate = Color(1.5, 0.5, 0.5, 1)
		affectedCravers[c] = originalSpeed

func _restore_slow(c) -> void:
	if not is_instance_valid(c):
		affectedCravers.erase(c) # hapus kalau sudah free
		return
	
	if not affectedCravers.has(c):
		return
	
	c.moveSpeed = affectedCravers[c]
	c.modulate = Color(1,1,1,1)
	affectedCravers.erase(c)
