extends Node

signal money_changed(new_value)
signal health_changed(new_value)

var _money: int = 0
var Money: int:
	get:
		return _money
	set(value):
		_money = value
		emit_signal("money_changed", value)
var MetaMoney = 0

var _health: int = 100
var Health: int:
	get:
		return _health
	set(value):
		_health = value
		emit_signal("health_changed", value)
