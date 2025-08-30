extends MarginContainer

@onready var shopSpawnerMenu = $HBoxContainer/NinePatchRect
@onready var toggleArea = $HBoxContainer/toggleMenu

func _ready() -> void:
	shopSpawnerMenu.visible = false
	shopSpawnerMenu.mouse_filter = Control.MOUSE_FILTER_STOP

	# connect sinyal (bisa lewat editor juga)
	toggleArea.mouse_entered.connect(_on_toggle_menu_mouse_entered)

func _on_toggle_menu_mouse_entered() -> void:
	shopSpawnerMenu.visible = true
	await get_tree().create_timer(3).timeout
	shopSpawnerMenu.visible = false
