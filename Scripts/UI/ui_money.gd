extends Control

@onready var money_label: Label = $Label

func _ready() -> void:
	z_index = 1008
	Global.connect("money_changed", Callable(self, "_on_money_changed"))
	_on_money_changed(Global.Money)

func _on_money_changed(value: int) -> void:
	money_label.text = "Money: " + str(value)
