extends Node2D

@export var initialMoney: int

func _ready() -> void:
	Global.Money = initialMoney
