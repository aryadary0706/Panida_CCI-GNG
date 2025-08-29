extends Area2D

@export var moneyMultiplier: float = 0.05
var affectedShops: Dictionary = {}  # Hanya menyimpan original money saja
@onready var ownShop = self.get_parent()
var effectColor = Color(0.5, 0.7, 1.0)  # Warna biru muda


func _ready():
	if ownShop and ownShop.has_signal("shop_placed"):
		ownShop.shop_placed.connect(on_shop_placed)

func _process(delta: float) -> void:
	z_index = Global.EffectLayer
	
func _on_area_entered(area: Area2D) -> void:
	var otherShop = area.get_parent()
	if otherShop.is_in_group("Shops") && ownShop.hasPlaced:
		affectedShops[otherShop] = otherShop.moneyMade
		otherShop.moneyMade *= (1 + moneyMultiplier)
		if otherShop.occupancyIndicator:
			otherShop.occupancyIndicator.active_color = effectColor
			otherShop.occupancyIndicator.update_indicator()
		
		print(otherShop, " money now is: ", otherShop.moneyMade, " | Color changed to blue")

func _on_area_exited(area: Area2D) -> void:
	var otherShop = area.get_parent()
	if otherShop.is_in_group("Shops") and otherShop in affectedShops:
		otherShop.moneyMade = affectedShops[otherShop]
		if otherShop.occupancyIndicator:
			otherShop.occupancyIndicator.active_color = Color(1,1,1)
			otherShop.occupancyIndicator.update_indicator()
		
		affectedShops.erase(otherShop)
		print(otherShop, " money restored to: ", otherShop.moneyMade, " | Color restored to white")

func apply_effect_to_existing_areas():
	if !self.get_parent().hasPlaced:
		return
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		var otherShop = area.get_parent()
		if otherShop.is_in_group("Shops") and otherShop not in affectedShops:
			affectedShops[otherShop] = otherShop.moneyMade
			otherShop.moneyMade *= (1 + moneyMultiplier)
			if otherShop.occupancyIndicator:
				otherShop.occupancyIndicator.active_color = effectColor
				otherShop.occupancyIndicator.update_indicator()
			
			print(otherShop, " money now is: ", otherShop.moneyMade, " | Color changed to blue")

func on_shop_placed():
	apply_effect_to_existing_areas()
