extends Shop
class_name ShopMieAyam

var craver_original_durations: Dictionary = {}

func _on_shop_body_body_entered(body: Node2D) -> void:
	if body is Craver and hasPlaced:
		print("MieAyam Shop: Changing eating duration to 2.0 for ", body.name)
		if not craver_original_durations.has(body):
			craver_original_durations[body] = body.eatingDuration
		body.eatingDuration = 2.0
	
	super._on_shop_body_body_entered(body)

func _on_shop_body_body_exited(body: Node2D) -> void:
	if body is Craver and craver_original_durations.has(body):
		print("MieAyam Shop: Restoring original duration for ", body.name)
		body.eatingDuration = craver_original_durations[body]
		craver_original_durations.erase(body)
	
	super._on_shop_body_body_exited(body)
