extends Area2D

@export var effectTime: float = 1.5
@export var cooldown: float = 5.0
@onready var areaColor = $AreaColor

var craversInArea: Array[Craver] = []
var stunnedCravers: Array[Craver] = []
var alrStunned: Array[Craver] = []
var stunOnCooldown: bool = false


func _ready() -> void:
	areaColor.visible = false

func _process(delta: float) -> void:
	z_index = Global.EffectLayer
	

func _on_body_entered(body: Node) -> void:
	if not self.get_parent().hasPlaced:
		return
	if body is Craver and body not in craversInArea:
		craversInArea.append(body)


func _on_body_exited(body: Node) -> void:
	if body is Craver:
		craversInArea.erase(body)
		# kalau keluar area, langsung hapus dari stunnedCravers juga
		if body in stunnedCravers:
			stunnedCravers.erase(body)
		_try_trigger_stun()


func _try_trigger_stun() -> void:
	_cleanup_invalids()

	if stunOnCooldown:
		return
	
	var eligible: Array[Craver] = []
	for c in craversInArea:
		if is_instance_valid(c) and c not in stunnedCravers and c not in alrStunned:
			eligible.append(c)
	
	if eligible.is_empty():
		return
	
	# Jalankan stun
	_stun_cravers(eligible)
	
	# Aktifkan cooldown
	stunOnCooldown = true
	GlobalFunctions.fade_in(areaColor, 0.5)
	await get_tree().create_timer(cooldown).timeout
	GlobalFunctions.fade_out(areaColor, 0.5)
	stunOnCooldown = false


func _stun_cravers(targets: Array) -> void:
	SfxPlayer.play_music(preload("res://audio/KenaEfekEs.ogg")) # efek es
	for c in targets:
		if not is_instance_valid(c): 
			continue
		
		var originalSpeed = c.moveSpeed
		c.direction = Vector2.ZERO
		c.moveSpeed = 0
		c.modulate = Color(0.3, 0.5, 1.0, 1.0)
		stunnedCravers.append(c)
		alrStunned.append(c)
		
		restore_stun(c, originalSpeed)


func restore_stun(craver: Craver, originalSpeed: float) -> void:
	async_restore(craver, originalSpeed)


func async_restore(craver: Craver, originalSpeed: float) -> void:
	await get_tree().create_timer(effectTime).timeout

	if is_instance_valid(craver):
		var craverSprite = craver.get_node("Sprite2D")
		craverSprite.stop()
		craver.moveSpeed = originalSpeed
		craver.modulate = Color(1,1,1,1)
	
	if craver in stunnedCravers:
		stunnedCravers.erase(craver)


func _cleanup_invalids() -> void:
	craversInArea = craversInArea.filter(is_instance_valid)
	stunnedCravers = stunnedCravers.filter(is_instance_valid)
	alrStunned = alrStunned.filter(is_instance_valid)
