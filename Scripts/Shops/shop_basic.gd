extends Node2D
class_name Shop

const moneyPopup = preload("res://Objects/Miscellaneous/money.tscn")

@export_enum("Vegan", "Normal", "All") var craverType = "Normal"
@export var maxCraver = 3
@export var priceToBuy = 400
@export var moneyMade = 100
@export var eatDistance = 32.0
@export var delay_time: float 
@export var placableTileIDs: Array[int] = []
@onready var tilemap_layer: TileMapLayer = get_tree().current_scene.find_child("PathAndObstacle", true, false)
@onready var shopArea: CollisionShape2D = $ShopBody/Collision
@onready var delay_timer: Timer = $DelayTimer  
var cravers: Array = []
var craverInside = 0
var isDragging = false
var isOverlapping = false
var canPlace = false
var hasPlaced = false
var isWaitingDelay = false 

var snap = 64

func _ready() -> void:
	add_to_group("Shops")
	z_index = 1000
	delay_timer.wait_time = delay_time


func start_delay() -> void:
	if not isWaitingDelay:
		# cek uang lebih dulu
		if Global.Money >= priceToBuy:
			Global.Money -= priceToBuy
		else:
			print("Not enough money, cannot build shop.")
			queue_free()
			return

		isWaitingDelay = true
		delay_timer.start()
		modulate = Color(1, 1, 0.5, 0.7)  # kuning artinya masih dibangun
		print("Shop delay started...")


# callback setelah timer selesai
func _on_delay_timer_timeout() -> void:
	isWaitingDelay = false
	hasPlaced = true
	modulate = Color(1, 1, 1, 1) # balik ke normal (aktif)
	print("Shop placed successfully after delay.")


func checkPlacableTile() -> bool:
	if !tilemap_layer or !shopArea:
		return false
	
	var rect_shape: RectangleShape2D = shopArea.shape
	var extents: Vector2 = rect_shape.extents
	var offsets = [
		Vector2(0, 0), # pusat
		Vector2(-extents.x, -extents.y),
		Vector2(extents.x, -extents.y),
		Vector2(-extents.x, extents.y),
		Vector2(extents.x, extents.y)
	]
	
	for offset in offsets:
		var world_pos = shopArea.global_position + offset
		var tile_pos = tilemap_layer.local_to_map(tilemap_layer.to_local(world_pos))
		var source_id = tilemap_layer.get_cell_source_id(tile_pos)
		
		if not (source_id in placableTileIDs):
			return false
	
	return true


func _process(delta: float) -> void:
	if isDragging and not hasPlaced:
		position = get_global_mouse_position().snapped(Vector2(snap, snap))
	
	canPlace = checkPlacableTile()
	
	if !isDragging and !isOverlapping and canPlace:
		if not isWaitingDelay and not hasPlaced:
			modulate = Color(1, 1, 1, 1) 
	elif isDragging and canPlace and !isOverlapping:
		modulate = Color(0.5, 1, 0.5, 0.5)
	elif !canPlace:
		modulate = Color(1, 0.5, 0.5, 0.5)


	# loop cravers tetap
	for i in range(cravers.size() - 1, -1, -1):
		var craver = cravers[i]
		
		if not is_instance_valid(craver):
			unregister_craver(craver)
			continue
			
		if craver.global_position.distance_to(global_position) <= eatDistance:
			if not craver.has_meta("is_eating") or craver.get_meta("is_eating") == false:
				craver.set_meta("is_eating", true)
				craver.set_meta("eat_timer", craver.eatingDuration)
			else:
				var timer = craver.get_meta("eat_timer") - delta
				craver.set_meta("eat_timer", timer)
				
				if timer <= 0:
					finish_eating(craver)
					unregister_craver(craver)
					craver.set_meta("is_eating", false)
					craver.isGoingToShop = false


func try_register_craver(craver) -> bool:
	if craverInside + craver.occupancy <= maxCraver and craverType == craver.craverType and craver.maxVisit > 0:
		if craver not in cravers:
			cravers.append(craver)
			craverInside += craver.occupancy
			craver.assignedShop = self
			return true
	return false


func unregister_craver(craver) -> void:
	if not is_instance_valid(craver):
		return
	
	if craver in cravers and craver.assignedShop == self:
		craverInside -= craver.occupancy
		cravers.erase(craver)
		craver.assignedShop = null
		craver.maxVisit -= 1
		spawn_coin_popup()


func finish_eating(craver) -> void:
	Global.Money += moneyMade * craver.occupancy
	

func spawn_coin_popup() -> void:
	SfxPlayer.play_music(preload("res://audio/coin.ogg"))
	
	var rect_shape: RectangleShape2D = shopArea.shape
	var size: Vector2 = rect_shape.extents * 2.0
	
	var offset = Vector2(
		randf_range(0, 2 * size.x),
		randf_range(-size.y, size.y)
	)

	var coin = moneyPopup.instantiate()
	coin.z_index = 1002
	get_tree().current_scene.add_child(coin)
	coin.global_position = global_position + offset  

	var tween = get_tree().create_tween()
	tween.tween_property(coin, "position", coin.position + Vector2(0, -50), 0.8)
	tween.parallel().tween_property(coin, "modulate:a", 0.0, 0.8)
	tween.tween_callback(Callable(coin, "queue_free"))


func _on_button_button_down() -> void:
	isDragging = true

func _on_button_button_up() -> void:
	isDragging = false
	if isOverlapping or !canPlace:
		queue_free()
	elif !hasPlaced and !isWaitingDelay:
		start_delay()   # <== sekarang mulai delay alih-alih langsung placed
	else:
		pass
		

func _on_shop_range_body_entered(body: Node2D) -> void:
	if !body.is_in_group(craverType):
		return
		
	if hasPlaced and body.assignedShop == null:
		if try_register_craver(body):
			body.getShop(self)
			body.assignedShop = self
			body.isGoingToShop = true
			body.target = global_position


func _on_shop_range_body_exited(body: Node2D) -> void:
	if hasPlaced:
		body.assignedShop = null
		

func _on_shop_body_area_entered(area: Area2D) -> void:
	var other_shop = area.get_parent()
	if other_shop.is_in_group("Shops") && other_shop != self:
		isOverlapping = true
		if !other_shop.hasPlaced:
			other_shop.modulate = Color(1, 0.5, 0.5, 0.5)
			print("overlap? ", isOverlapping)


func _on_shop_body_area_exited(area: Area2D) -> void:
	isOverlapping = false
