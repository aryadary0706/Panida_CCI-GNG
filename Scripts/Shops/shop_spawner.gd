extends Node2D

@export var shopScene: PackedScene
var spawnedShop: Shop = null

func get_shop_price(scene: PackedScene) -> int:
	var temp_shop = scene.instantiate() as Shop
	var price = temp_shop.priceToBuy
	temp_shop.queue_free() # biar gak nyampah di scene tree
	return price

	
func spawnShop():
	if shopScene:
		spawnedShop = shopScene.instantiate()
		spawnedShop.isDragging = true
		get_tree().current_scene.add_child(spawnedShop)


func _on_button_button_down() -> void:
	var price = get_shop_price(shopScene)
	if Global.Money >= price:
		SfxPlayer.play_music(preload("res://audio/click.ogg"))
	spawnShop()
