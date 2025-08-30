extends Control
class_name RefundUI

signal refund_confirmed
signal refund_cancelled

@onready var label: Label = $Panel/HBoxContainer/MoneyAmount
@onready var refund_button: Button = $Panel/HBoxContainer2/RefundButton
@onready var cancel_button: Button = $Panel/HBoxContainer2/CancelButton


var refund_value: int = 0

func set_refund_value(value: int) -> void:
	refund_value = value
	label.text = "%d" % value

func _on_cancel_button_pressed() -> void:
	queue_free()


func _on_refund_button_pressed() -> void:
	Global.Money -= refund_value
	get_parent().spawn_coin_popup()
	get_parent().queue_free()
	queue_free()
