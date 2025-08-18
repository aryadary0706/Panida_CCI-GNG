extends CharacterBody2D
class_name Craver

@export_enum("Vegan", "Normal") var craverType = "Normal"
@export var eatingDuration: float = 3.5
@export var occupancy = 1
@export var healthLoss = 10
@export var moveSpeed = 100
@onready var navAgent = $Navigation
@onready var anim = $Sprite2D


var shopDetected: Node2D
var assignedShop: Shop = null
var target: Vector2
var direction: Vector2
var endPos: Vector2
var acceleration = 7
var hasAssignedShop = false
var isGoingToShop: bool = false

func _ready() -> void:
	add_to_group(craverType)
	var end_goal = get_tree().root.get_node("Game/EndGoal")
	if end_goal:
		var randOfX = randf_range(-15, 15)
		var randOfY = randf_range(-15, 15)
		endPos = end_goal.global_position
		target = Vector2(endPos.x + randOfX, endPos.y + randOfY)
		navAgent.target_position = target

func _physics_process(delta: float) -> void:
	if isGoingToShop:
		direction = (target - global_position).normalized()
	else:
		navAgent.target_position = target
		if !navAgent.is_navigation_finished():
			direction = (navAgent.get_next_path_position() - global_position).normalized()
	
	# Apply movement
	if direction:
		velocity = velocity.lerp(direction * moveSpeed, acceleration * delta)
		move_and_slide()
		update_animation()

		

func getShop(shopDetected):
	if shopDetected.craverType == craverType && (shopDetected.craverInside + occupancy <= shopDetected.maxCraver) && !hasAssignedShop && shopDetected.hasPlaced:
		hasAssignedShop = true
		isGoingToShop = true
		target = shopDetected.global_position
		
func update_animation() -> void:
	if direction == Vector2.ZERO:
		anim.stop()
		return

	# pilih animasi sesuai arah dominan
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("right")
		else:
			anim.play("left")
	else:
		if direction.y > 0:
			anim.play("front") # ke bawah
		else:
			anim.play("back")  # ke atas
