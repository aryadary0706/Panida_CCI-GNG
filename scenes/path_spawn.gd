extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer

var wave_data: Array = []
var spawn_count: int = 0
var is_wave_active: bool = false

func _ready():
	randomize()
	spawn_timer.one_shot = false
	spawn_timer.wait_time = 0.5 
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))

func start_wave(wave_data_input: Array) -> void:
	wave_data = wave_data_input.duplicate()
	spawn_count = 0
	is_wave_active = true
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if is_wave_active and spawn_count < 3:
		var random_index = randi_range(0, wave_data.size() - 1)
		spawn_enemy(wave_data[random_index])
		spawn_count += 1
	else:
		is_wave_active = false
		spawn_timer.stop()

func spawn_enemy(enemy_info: Dictionary) -> void:
	var enemy_type = enemy_info["type"]
	var enemy_scene: PackedScene
	#Ini gua samain dlu rutenya, siapa tau ada yg bakal diubah
	if enemy_type == "enemy_basic":
		enemy_scene = preload("res://scenes/route/Entity_route.tscn")
	elif enemy_type == "enemy_pro":
		enemy_scene = preload("res://scenes/route/Entity_route.tscn")
		#Tambahin disini tergantung tipe dari route yang ada
	
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		add_child(enemy)
