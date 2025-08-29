extends Area2D

@export var moneyMultiplier: float = 0.05
var affectedShops: Dictionary = {}
@onready var ownShop = self.get_parent()


func _ready():
	z_as_relative = false
	z_index = 2
	if ownShop and ownShop.has_signal("shop_placed"):
		ownShop.shop_placed.connect(on_shop_placed)

func _on_area_entered(area: Area2D) -> void:
	var otherShop = area.get_parent()
	if otherShop is Shop and otherShop != self.get_parent() and otherShop.hasPlaced:
		if not affectedShops.has(otherShop):
			affectedShops[otherShop] = otherShop.moneyMade
		otherShop.moneyMade = affectedShops[otherShop] * (1 + moneyMultiplier)
		print(otherShop, " money now is: ", otherShop.moneyMade)

func _on_area_exited(area: Area2D) -> void:
	var otherShop = area.get_parent()
	if otherShop is Shop and affectedShops.has(otherShop):
		otherShop.moneyMade = affectedShops[otherShop]
		affectedShops.erase(otherShop)
		print(otherShop, " money restored to: ", otherShop.moneyMade)


func apply_effect_to_existing_areas():
	if !self.get_parent().hasPlaced:
		return
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		var otherShop = area.get_parent()
		if otherShop.is_in_group("Shops") and otherShop not in affectedShops:
			affectedShops[otherShop] = otherShop.moneyMade
			otherShop.moneyMade *= (1 + moneyMultiplier)
			print(otherShop, " money now is: ", otherShop.moneyMade)

func on_shop_placed():
	apply_effect_to_existing_areas()
