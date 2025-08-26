extends CharacterBody2D
class_name Craver

@export_enum("Vegan", "Normal") var craverType = "Normal"
@export var eatingDuration: float = 3.5
@export var occupancy = 1
@export var maxVisit = 1
@export var healthLoss = 10
@export var moveSpeed = 100.0
@onready var navAgent = $Navigation
@onready var anim = $Sprite2D

var availableShops: Array[Shop] = []  # List shop yang available
var assignedShop: Shop = null
var visitedShops: Array[Shop] = []
var target: Vector2
var direction: Vector2
var endPos: Vector2
var acceleration = 7
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

func _process(delta: float) -> void:
	if maxVisit <= 0:
		queue_free()
	
	if !isGoingToShop:
		z_index = global_position.y
		try_assign_shop()
	elif isGoingToShop:
		z_index = 1
	
func _physics_process(delta: float) -> void:
	if isGoingToShop and assignedShop:
		# Pergi ke shop yang ditugaskan
		direction = (assignedShop.global_position - global_position).normalized()
	else:
		# Pergi ke tujuan akhir
		navAgent.target_position = endPos
		if !navAgent.is_navigation_finished():
			direction = (navAgent.get_next_path_position() - global_position).normalized()
	
	# Apply movement
	if direction:
		velocity = velocity.lerp(direction * moveSpeed, acceleration * delta)
		move_and_slide()
		update_animation()

# Fungsi untuk menambah shop ke available list (dipanggil oleh Shop)
func add_available_shop(shop: Shop) -> void:
	if (shop.hasPlaced and 
		shop.craverType == craverType and 
		shop not in visitedShops and
		shop not in availableShops and
		shop.craverInside + occupancy <= shop.maxCraver):
		
		availableShops.append(shop)
		print("for craver ", self.name, ", Shop added to available list: ", availableShops)
		
		
# Fungsi untuk memilih shop dari available list
func try_assign_shop() -> void:
	if assignedShop or isGoingToShop or maxVisit <= 0 or availableShops.is_empty():
		return
	
	# Pilih shop terdekat dari available shops
	availableShops.sort_custom(func(a, b): 
		return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)
	)
	
	assignedShop = availableShops[0]
	isGoingToShop = true
	target = assignedShop.global_position
	
	# Langsung tambahkan ke visited shops dan hapus dari available
	visitedShops.append(assignedShop)
	availableShops.erase(assignedShop)
	
	# Daftarkan diri ke shop
	if assignedShop.try_register_craver(self):
		print("Craver assigned to shop: ", assignedShop.name)
	else:
		# Jika gagal register, reset assignment
		visitedShops.erase(assignedShop)
		assignedShop = null
		isGoingToShop = false

# Fungsi untuk menangani setelah selesai makan (dipanggil oleh Shop)
func on_finished_eating() -> void:
	if assignedShop:
		assignedShop = null
		isGoingToShop = false
		# Coba cari shop lagi jika masih ada kunjungan tersisa
		if maxVisit > 0 and not availableShops.is_empty():
			try_assign_shop()

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
		else:
			anim.play("back")
