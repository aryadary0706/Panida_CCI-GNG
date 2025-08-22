extends Node2D

@onready var wave_manager = get_parent().get_node("WaveManager")

func _ready() -> void:
	wave_manager.connect("game_ended", Callable(self, "game_over"))
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.queue_free()
		Global.Health -= body.healthLoss
		print("You have ", Global.Health, " health left")
		if Global.Health <= 0:
			game_over()	
			

func game_over() -> void:
	Engine.time_scale = 0.0  
	#var canvas_layer = CanvasLayer.new()
	#var color_rect = ColorRect.new()
	#color_rect.color = Color(0, 0, 0, 0.5)
	#color_rect.size = get_viewport_rect().size
#
	#var shader = Shader.new()
	#shader.code = """
	#shader_type canvas_item;
#
	#void fragment() {
		#vec4 tex = texture(SCREEN_TEXTURE, SCREEN_UV);
		#float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
		#COLOR = vec4(vec3(gray), tex.a);
	#}
	#"""
#
	#var shader_material = ShaderMaterial.new()
	#shader_material.shader = shader
	#color_rect.material = shader_material
#
	#canvas_layer.add_child(color_rect)
	#get_tree().root.add_child(canvas_layer)
	$"../game_over".get_node("GameOverUI").show()
	

	print("GAME OVER")
