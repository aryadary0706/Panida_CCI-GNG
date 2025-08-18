extends Node2D
class_name Shop

const moneyPopup = preload("res://Objects/Miscellaneous/money.tscn")

@export_enum("Vegan", "Normal", "All") var craverType = "Normal"
@export var maxCraver = 3
@export var priceToBuy = 400
@export var moneyMade = 100
@export var eatDistance = 32.0
@export var placableTileIDs: Array[int] = []
@onready var tilemap_layer: TileMapLayer = get_tree().current_scene.find_child("PathAndObstacle", true, false)
@onready var shopArea: CollisionShape2D = $ShopBody/Collision
var cravers: Array = []
var craverInside = 0
var isDragging = false
var isOverlapping = false
var canPlace = false
var hasPlaced = false

var snap = 64

func _ready() -> void:
	add_to_group("Shops")

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
		modulate = Color(1, 1, 1, 1) 
	elif isDragging and canPlace and !isOverlapping:
		modulate = Color(0.5, 1, 0.5, 0.5)
	elif !canPlace:
		modulate = Color(1, 0.5, 0.5, 0.5)


	for i in range(cravers.size() - 1, -1, -1):
		var craver = cravers[i]
		
		
		if not is_instance_valid(craver):
			unregister_craver(craver)
			continue
			
		if craver.global_position.distance_to(global_position) <= eatDistance:
			if not craver.has_meta("is_eating"):
				craver.set_meta("is_eating", true)
				craver.set_meta("eat_timer", craver.eatingDuration)
				craver.visible = false  # Sembunyikan saat makan
			else:
				var timer = craver.get_meta("eat_timer") - delta
				craver.set_meta("eat_timer", timer)
				
				if timer <= 0:
					finish_eating(craver)
					unregister_craver(craver)
					craver.queue_free()

func try_register_craver(craver) -> bool:
	if craverInside + craver.occupancy <= maxCraver and craverType == craver.craverType:
		if craver not in cravers:
			cravers.append(craver)
			craverInside += craver.occupancy
			craver.assignedShop = self
			return true
	return false



func unregister_craver(craver) -> void:
	if not is_instance_valid(craver):
		return
	
	# hanya unregister kalau craver ini memang terikat ke shop ini
	if craver in cravers and craver.assignedShop == self:
		craverInside -= craver.occupancy
		cravers.erase(craver)
		craver.assignedShop = null
		spawn_coin_popup()



func finish_eating(craver) -> void:
	Global.Money += moneyMade * craver.occupancy
	

func spawn_coin_popup() -> void:
	var rect_shape: RectangleShape2D = shopArea.shape
	var size: Vector2 = rect_shape.extents * 2.0
	
	# posisi random dalam area
	var offset = Vector2(
		randf_range(-size.x / 2, size.x / 2),
		randf_range(-size.y * 2, -size.y)
	)

	var coin = moneyPopup.instantiate()
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
	elif !hasPlaced:
		hasPlaced = true
		if Global.Money >= priceToBuy:
			Global.Money -= priceToBuy
		else:
			queue_free()
	else:
		pass
		

func _on_shop_range_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Vegan") and not body.is_in_group("Normal"):  # Pastikan body adalah craver
		return
		
	if hasPlaced and body.assignedShop == null:
		# Coba daftarkan dulu, baru beri tahu craver jika berhasil
		if try_register_craver(body):
			body.assignedShop = self
			body.isGoingToShop = true
			body.target = global_position


func _on_shop_range_body_exited(body: Node2D) -> void:
	body.getShop(self)
	if hasPlaced:
		body.assignedShop = null
		



func _on_shop_body_area_entered(area: Area2D) -> void:
	var other_shop = area.get_parent()  # Ambil parent Area2D (harusnya Shop)
	if other_shop.is_in_group("Shops") && other_shop != self:
		isOverlapping = true
		other_shop.modulate = Color(1, 0.5, 0.5, 0.5)
		print("overlap? ", isOverlapping)


func _on_shop_body_area_exited(area: Area2D) -> void:
	isOverlapping = false
		
