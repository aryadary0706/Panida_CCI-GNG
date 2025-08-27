extends Node2D

@export var initialMoney: int
@onready var decorationLayer = $Decorations

func _ready() -> void:
	Global.Money = initialMoney
	#decorationLayer.z_index = 1005
	

func _on_level_completed():
	GlobalProgress.unlocked_level += 1
	GlobalProgress.save_progress()
