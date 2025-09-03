extends Control

@export var initialMoney: int
@export var initialHealth: int
@onready var InGameUI = $InGameUI
@onready var waveManager = $WaveManager
@onready var Decor = $Decoration

func _ready() -> void:
	Global.Money = initialMoney
	Global.Health = initialHealth
	InGameUI.z_index = 1000
	waveManager.z_index = InGameUI.z_index
	Decor.z_index = 1
	
