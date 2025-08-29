extends Shop
class_name ShopMieAyam

var craver_original_durations: Dictionary = {}

func _ready():
	super._ready()
	# Connect manual ke body_exited karena parent tidak melakukannya
	if not $ShopBody.body_exited.is_connected(_on_shop_body_body_exited):
		$ShopBody.body_exited.connect(_on_shop_body_body_exited)

func _on_shop_body_body_entered(body: Node2D) -> void:
	if body is Craver and hasPlaced:
		if not craver_original_durations.has(body):
			craver_original_durations[body] = body.eatingDuration
		body.eatingDuration = 3.0
		print("MieAyam: Changed eating duration to 2.0 for ", body.name)
	
	super._on_shop_body_body_entered(body)

func _on_shop_body_body_exited(body: Node2D) -> void:
	if body is Craver and craver_original_durations.has(body):
		body.eatingDuration = craver_original_durations[body]
		craver_original_durations.erase(body)
		print("MieAyam: Restored original duration for ", body.name)
	
	# Tetap panggil super meskipun kosong untuk konsistensi
	super._on_shop_body_body_exited(body)
