extends Control

@onready var money_label: Label = $Label

func _ready() -> void:
	# Hubungkan ke signal dari Global
	Global.connect("money_changed", Callable(self, "_on_money_changed"))
	# Tampilkan uang awal
	_on_money_changed(Global.Money)

func _on_money_changed(value: int) -> void:
	money_label.text = "Money: " + str(value)
