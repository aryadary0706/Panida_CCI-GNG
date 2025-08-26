extends Area2D

@export var effectTime: float = 3.0
@export var slowPercentage: float = 0.9
@export var cooldown: float = 5.0

var affectedCravers: Dictionary = {}
var craversInArea: Array = []

func _ready():
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	# Update timers for all affected cravers
	for craver in affectedCravers.keys():
		if is_instance_valid(craver):
			affectedCravers[craver].time_remaining -= delta
			if affectedCravers[craver].time_remaining <= 0:
				_remove_slow_effect(craver)
		else:
			affectedCravers.erase(craver)
	
	# Apply slow effect to all cravers currently in area
	for body in craversInArea:
		if is_instance_valid(body) and body is Craver:
			# Jika craver belum ada di affectedCravers, apply effect
			if body not in affectedCravers:
				_apply_slow_effect(body)
			# Jika sudah ada, reset timer selama masih di area
			elif body in affectedCravers:
				affectedCravers[body].time_remaining = effectTime

func _on_body_entered(body):
	if !self.get_parent().hasPlaced:
		return
	
	if body is Craver:
		if body not in craversInArea:
			craversInArea.append(body)

func _on_body_exited(body):
	if body is Craver:
		if body in craversInArea:
			craversInArea.erase(body)
		# Timer effect akan terus berjalan sampai habis setelah keluar area

func _apply_slow_effect(body: Craver) -> void:
	# Check if craver is on cooldown
	if body.has_method("is_slow_cooldown_active") and body.is_slow_cooldown_active():
		return
	
	#SfxPlayer.play_music(preload("res://audio/KenaEfekEs.ogg")) #Gua tambahin efek es disini hehe
	var originalSpeed = body.moveSpeed
	body.moveSpeed *= (1.0 - slowPercentage)
	body.modulate = Color(0.5, 0.7, 1.5, 1)
	
	# Store both original speed and remaining time
	affectedCravers[body] = {
		"original_speed": originalSpeed,
		"time_remaining": effectTime
	}
	
	# Add a cooldown flag to the craver to prevent immediate re-application
	if body.has_method("set_slow_cooldown"):
		body.set_slow_cooldown(cooldown)

func _remove_slow_effect(body: Craver) -> void:
	if is_instance_valid(body) and body in affectedCravers:
		body.moveSpeed = affectedCravers[body].original_speed
		affectedCravers.erase(body)
		body.modulate = Color(1, 1, 1, 1)
