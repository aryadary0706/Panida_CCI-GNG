extends Node2D

@export var initialMoney: int

func _ready() -> void:
	Global.Money = initialMoney

func _on_level_completed():
	GlobalProgress.unlocked_level += 1
	GlobalProgress.save_progress()
