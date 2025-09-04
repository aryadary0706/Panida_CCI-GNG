extends CharacterBody2D
class_name Craver

@export_enum("Vegan", "Normal") var craverType = "Normal"
@export var tier = 1
@export var eatingDuration: float = 3.5
@export var occupancy = 1
@export var maxVisit = 1
@export var healthLoss = 10
@export var moveSpeed = 100.0
@onready var navAgent = $Navigation
@onready var anim = $Sprite2D

var availableShops: Array[Shop] = []
var assignedShop: Shop = null
var visitedShops: Array[Shop] = []
var target: Vector2
var direction: Vector2
var endPos: Vector2
var acceleration = 7
var isGoingToShop: bool = false
var isEating: bool

var isSpeedModified = false

func _ready() -> void:
	add_to_group(craverType)
	var end_goal = get_tree().root.get_node("Game/EndGoal")
	if end_goal:
		var randOfX = randf_range(-15, 15)
		var randOfY = randf_range(-15, 15)
		endPos = end_goal.global_position
		target = Vector2(endPos.x + randOfX, endPos.y + randOfY)
		navAgent.target_position = target

func _process(delta: float) -> void:
	if maxVisit <= 0:
		queue_free()

	if !isGoingToShop:
		z_index = global_position.y

	if isGoingToShop and assignedShop != null and !isEating:
		if !is_shop_still_valid(assignedShop):
			if assignedShop:
				assignedShop.reservedSlots = max(0, assignedShop.reservedSlots - occupancy)
			isGoingToShop = false
			assignedShop = null
			if availableShops.size() > 0:
				assign_shop()

	update_animation()

func _physics_process(delta: float) -> void:
	if isGoingToShop and assignedShop != null:
		direction = (assignedShop.global_position - global_position).normalized()
	else:
		navAgent.target_position = endPos
		if !navAgent.is_navigation_finished():
			direction = (navAgent.get_next_path_position() - global_position).normalized()
	if direction:
		velocity = velocity.lerp(direction * moveSpeed, acceleration * delta)
		move_and_slide()

func is_shop_still_valid(shop: Shop) -> bool:
	if shop == null:
		return false
	if !shop.hasPlaced:
		return false
	if !(shop.craverType == craverType or shop.craverType == "All"):
		return false
	if shop.craverInside + shop.reservedSlots > shop.maxCraver:
		return false
	return true


func add_available_shop(shop: Shop):
	if maxVisit <= 0:
		return
	# >>> Gunakan logika shop.can_accept (sudah termasuk reserved) <<<
	if shop not in visitedShops and shop not in availableShops and shop.can_accept(self):
		availableShops.append(shop)
		if availableShops.size() >= 1:
			assign_shop()

func assign_shop():
	availableShops.sort_custom(func(a: Shop, b: Shop) -> bool:
		var dist_a = global_position.distance_to(a.global_position)
		var dist_b = global_position.distance_to(b.global_position)
		if dist_a == dist_b:
			return a.craverInside < b.craverInside
		return dist_a < dist_b
	)
	assignedShop = availableShops[0]
	isGoingToShop = true
	target = assignedShop.global_position
	availableShops.erase(assignedShop)
	if assignedShop != null:
		assignedShop.reservedSlots += occupancy

func eating():
	AudioPlayer.play_sfx(preload("res://audio/Pop.ogg"))
	isEating = true
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	visitedShops.append(assignedShop)
	await get_tree().create_timer(eatingDuration).timeout
	isEating = false
	isGoingToShop = false
	visible = true
	if assignedShop != null:
		Global.Money += assignedShop.moneyMade
		assignedShop.spawn_coin_popup()
		maxVisit -= 1


func update_animation() -> void:
	if direction == Vector2.ZERO:
		anim.stop()
		return
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("right")
		else:
			anim.play("left")
	else:
		if direction.y > 0:
			anim.play("front")
			if isGoingToShop and assignedShop != null:
				z_index = assignedShop.global_position.y - 1
		else:
			anim.play("back")
			if isGoingToShop and assignedShop != null:
				z_index = assignedShop.global_position.y + 1

#####EFFECT SLOW DAN STUN BERUBAH DISINI AJA
func effect_slow(time: float, amount: float):
	if isSpeedModified:
		return
	isSpeedModified = true
	var temp = moveSpeed
	moveSpeed = (1 - amount) * moveSpeed
	modulate = Color(1.5, 0.5, 0.5, 1)
	print("SLOW ACTIVE")
	AudioPlayer.play_sfx(preload("res://audio/Slowed.ogg"))
	await get_tree().create_timer(time).timeout
	modulate = Color(1, 1, 1, 1)
	moveSpeed = temp
	isSpeedModified = false

func effect_stun(time: float):
	if isSpeedModified:
		return
	isSpeedModified = true
	var temp = moveSpeed
	moveSpeed = 0
	modulate = Color(0.5, 0.5, 1.5, 1)
	print("STUN ACTIVE")
	AudioPlayer.play_sfx(preload("res://audio/Stunned.ogg"))
	await get_tree().create_timer(time).timeout
	modulate = Color(1, 1, 1, 1)
	moveSpeed = temp
	isSpeedModified = false
