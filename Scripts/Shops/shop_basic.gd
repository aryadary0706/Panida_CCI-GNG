extends Node2D
class_name Shop
signal shop_placed
const moneyPopup = preload("res://Objects/Miscellaneous/money.tscn")

@export_enum("Vegan", "Normal", "All") var craverType = "Normal"
@export var maxCraver = 3
@export var priceToBuy = 400
@export var moneyMade = 100
@export var delay_time: float 
@export var placableTileIDs: Array[int] = []
@onready var tilemap_layer: TileMapLayer = get_tree().current_scene.find_child("PathAndObstacle", true, false)
@onready var shopArea: CollisionShape2D = $ShopBody/Collision
@onready var delay_timer: Timer = $DelayTimer  
@onready var sprite = $AnimatedSprite2D
@onready var occupancyIndicator = preload("res://Objects/Miscellaneous/occupancy_indicator.tscn")
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
	occupancyIndicator = occupancyIndicator.instantiate()
	add_child(occupancyIndicator)
	occupancyIndicator.setup(self)
	z_index = 1000
	delay_timer.wait_time = delay_time

func start_delay() -> void:
	if not isWaitingDelay && !hasPlaced:
		if Global.Money >= priceToBuy:
			Global.Money -= priceToBuy
		else:
			print("Not enough money, cannot build shop.")
			queue_free()
			return

		isWaitingDelay = true
		delay_timer.start()
		sprite.modulate = Color(1, 1, 0.5, 0.7)
		print("Shop delay started...")

func _on_delay_timer_timeout() -> void:
	isWaitingDelay = false
	hasPlaced = true
	sprite.modulate = Color(1, 1, 1, 1)
	print("Shop placed successfully after delay.")
	get_node("DelayTimer").queue_free()
	SfxPlayer.play_music(preload("res://audio/PlaceBuilding.ogg"))
	emit_signal("shop_placed")

func checkPlacableTile() -> bool:
	if !tilemap_layer or !shopArea:
		return false
	
	var rect_shape: RectangleShape2D = shopArea.shape
	var extents: Vector2 = rect_shape.extents
	var offsets = [
		Vector2(0, 0),
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
	
	z_index = global_position.y 
	#bagian placement
	if isDragging and not hasPlaced:
		position = get_global_mouse_position().snapped(Vector2(snap, snap))
	
	canPlace = checkPlacableTile()
	if !isDragging and !isOverlapping and canPlace:
		if not isWaitingDelay and not hasPlaced:
			sprite.modulate = Color(1, 1, 1, 1) 
	elif isDragging and canPlace and !isOverlapping:
		sprite.modulate = Color(0.5, 1, 0.5, 0.5)
	elif !canPlace:
		sprite.modulate = Color(1, 0.5, 0.5, 0.5)
		

func spawn_coin_popup():
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
	tween.tween_callback(coin.queue_free)



#ini bagian collision dengan craver
func _on_shop_range_body_entered(body: Node2D) -> void:
	if body is Craver && body.assignedShop == null:
		body.add_available_shop(self)

func _on_shop_range_body_exited(body: Node2D) -> void:
	pass

func _on_shop_body_body_entered(body: Node2D) -> void:
	if body is Craver && hasPlaced:
		craverInside += body.occupancy
		occupancyIndicator.update_indicator()
		GlobalFunctions.fade_out(body, 2)
		body.eating()
		
func _on_shop_body_body_exited(body: Node2D) -> void:
	if body is Craver && hasPlaced:
		craverInside -= body.occupancy
		occupancyIndicator.update_indicator()
		GlobalFunctions.fade_in(body, 0.3)
		

#ini bagian untuk collision antar shop biar ga numpuk
func _on_shop_body_area_entered(area: Area2D) -> void:
	var otherShop = area.get_parent()
	if otherShop is not Shop:
		return

	var otherShopSprite = otherShop.get_node("AnimatedSprite2D")
	if area.name == "ShopBody" && area != self:
		isOverlapping = true
		if !otherShop.hasPlaced:
			otherShopSprite.modulate = Color(1, 0.5, 0.5, 0.5)

func _on_shop_body_area_exited(area: Area2D) -> void:
	isOverlapping = false
	
func _on_button_button_down() -> void:
	if !hasPlaced:
		isDragging = true

func _on_button_button_up() -> void:
	isDragging = false
	if isOverlapping or !canPlace:
		queue_free()
	elif !hasPlaced and !isWaitingDelay:
		start_delay()
	if hasPlaced:
		sprite.play()
