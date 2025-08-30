extends Area2D

@export var effectTime: float = 1.5
@export var cooldown: float = 5.0
@export var slowPercentage: float = 0.3
@onready var areaColor = $AreaColor

var craversInArea: Array[Craver] = []
var slowedCravers: Array[Craver] = []
var alrSlowed: Array[Craver] = []
var slowOnCooldown: bool = false


func _ready() -> void:
	z_as_relative = false
	z_index = 2
	hide()

func _on_body_entered(body: Node) -> void:
	if not self.get_parent().hasPlaced:
		return
	if body is Craver and body not in craversInArea:
		craversInArea.append(body)


func _on_body_exited(body: Node) -> void:
	if body is Craver:
		craversInArea.erase(body)
		if body in slowedCravers:
			slowedCravers.erase(body)
		_try_trigger_stun()


func _try_trigger_stun() -> void:
	_cleanup_invalids()

	if slowOnCooldown:
		return
	
	var eligible: Array[Craver] = []
	for c in craversInArea:
		if is_instance_valid(c) and c not in slowedCravers and c not in alrSlowed:
			eligible.append(c)
	
	if eligible.is_empty():
		return
	
	# Jalankan stun
	_stun_cravers(eligible)
	
	# Aktifkan cooldown
	slowOnCooldown = true
	GlobalFunctions.fade_in(self)
	await get_tree().create_timer(cooldown).timeout
	GlobalFunctions.fade_out(self)
	slowOnCooldown = false


func _stun_cravers(targets: Array) -> void:
	SfxPlayer.play_music(preload("res://audio/KenaEfekEs.ogg")) #Gua tambahin efek es disini hehe
	for c in targets:
		if not is_instance_valid(c): 
			continue
		
		var originalSpeed = c.moveSpeed
		var craverSprite = c.get_node("Sprite2D")
		craverSprite.stop()
		c.moveSpeed = c.moveSpeed * (1-slowPercentage)
		c.modulate = Color(1.5, 0.5, 0.5, 1.0)
		slowedCravers.append(c)
		alrSlowed.append(c)
		
		restore_slow(c, originalSpeed)


func restore_slow(craver: Craver, originalSpeed: float) -> void:
	async_restore(craver, originalSpeed)


func async_restore(craver: Craver, originalSpeed: float) -> void:
	await get_tree().create_timer(effectTime).timeout

	if is_instance_valid(craver):
		var craverSprite = craver.get_node("Sprite2D")
		craverSprite.stop()
		craver.moveSpeed = originalSpeed
		craver.modulate = Color(1,1,1,1)
	
	if craver in slowedCravers:
		slowedCravers.erase(craver)


func _cleanup_invalids() -> void:
	craversInArea = craversInArea.filter(is_instance_valid)
	slowedCravers = slowedCravers.filter(is_instance_valid)
	alrSlowed = alrSlowed.filter(is_instance_valid)
