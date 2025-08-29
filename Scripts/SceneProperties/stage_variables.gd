extends Node2D

@export var initialMoney: int
@onready var InGameUI = $InGameUI
@onready var waveManager = $WaveManager

func _ready() -> void:
	Global.Money = initialMoney
	InGameUI.z_index = 1000
	waveManager.z_index = InGameUI.z_index
	

func _on_level_completed():
	GlobalProgress.unlocked_level += 1
	GlobalProgress.save_progress()
