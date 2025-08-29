extends Control

@export var shopScene: PackedScene
var spawnedShop: Shop = null
@onready var priceLabel: RichTextLabel = $Button/PriceLabel
@onready var texture: TextureRect = $Button/ShopTexture

func _ready() -> void:
	z_index = 1008
	
	if shopScene != null:
		var tempShop = shopScene.instantiate()
		
		# Set price label
		priceLabel.text = "[fill]" + str(tempShop.priceToBuy) + "[/fill]"
		priceLabel.bbcode_enabled = true
		
		# Ambil texture dari frame pertama AnimatedSprite2D
		var animated_sprite = tempShop.find_child("AnimatedSprite2D") as AnimatedSprite2D
		if animated_sprite:
			# Coba ambil dari sprite_frames pertama
			if animated_sprite.sprite_frames:
				var animations = animated_sprite.sprite_frames.get_animation_names()
				if animations.size() > 0:
					var first_anim = animations[0]
					var first_frame = animated_sprite.sprite_frames.get_frame_texture(first_anim, 0)
					if first_frame:
						texture.texture = first_frame
						texture.stretch_mode = TextureRect.STRETCH_SCALE
						texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			# Fallback ke texture biasa
			elif animated_sprite.texture:
				texture.texture = animated_sprite.texture
		
		tempShop.queue_free()

func get_shop_price(scene: PackedScene) -> int:
	var temp_shop = scene.instantiate() as Shop
	var price = temp_shop.priceToBuy
	temp_shop.queue_free()
	return price

func spawnShop():
	if shopScene:
		spawnedShop = shopScene.instantiate()
		spawnedShop.isDragging = true
		get_tree().current_scene.add_child(spawnedShop)

func _on_button_button_down() -> void:
	var price = get_shop_price(shopScene)
	if Global.Money >= price:
		SfxPlayer.play_music(preload("res://audio/click.ogg"))
		spawnShop()
