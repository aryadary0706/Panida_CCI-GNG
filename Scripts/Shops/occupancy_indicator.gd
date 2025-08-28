extends Control
class_name OccupancyIndicator

@export var indicator_texture: Texture2D
var shop: Shop = null

@onready var hbox := $HBoxContainer

func setup(target_shop: Shop) -> void:
	shop = target_shop
	# hapus isi lama
	for child in hbox.get_children():
		child.queue_free()

	# spawn lingkaran sesuai maxCraver
	for i in range(shop.maxCraver):
		var indicator = TextureRect.new()
		indicator.texture = indicator_texture
		indicator.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		indicator.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		indicator.custom_minimum_size = Vector2(16, 16) # biar seragam
		indicator.modulate = Color(0.5, 0.5, 0.5) # abu abu default
		hbox.add_child(indicator)

	update_indicator()

func update_indicator() -> void:
	if shop == null:
		return
	var inside = shop.craverInside
	for i in range(hbox.get_child_count()):
		var indicator = hbox.get_child(i) as TextureRect
		if i < inside:
			indicator.modulate = Color(1,1,1)  # putih
		else:
			indicator.modulate = Color(0.5,0.5,0.5)  # abu abu
