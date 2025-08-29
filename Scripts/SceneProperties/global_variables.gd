extends Node

signal money_changed(new_value)

var _money: int = 0
var Money: int:
	get:
		return _money
	set(value):
		_money = value
		emit_signal("money_changed", value)
var MetaMoney = 0
var Health = 100
var CraverLayer = 0
var EffectLayer = 1
var ShopLayer = 2
