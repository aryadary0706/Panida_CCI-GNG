extends Node2D

@export var shopScene: PackedScene
var spawnedShop: Shop = null

	
func spawnShop():
	if shopScene:
		spawnedShop = shopScene.instantiate()
		spawnedShop.isDragging = true
		get_tree().current_scene.add_child(spawnedShop)


func _on_button_button_down() -> void:
	spawnShop()
