extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_duration_timer: Timer = $DurationTimer

var wave_data: Array = []
var current_index: int = 0
var is_wave_active: bool = false

func _ready():
	spawn_timer.one_shot = false
	spawn_timer.wait_time = 0.5
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	
	wave_duration_timer.one_shot = true
	wave_duration_timer.wait_time = 15.0
	wave_duration_timer.connect("timeout", Callable(self, "_on_wave_duration_timeout"))

func start_wave(wave_data_input: Array) -> void:
	wave_data = wave_data_input.duplicate()
	current_index = 0
	is_wave_active = true
	spawn_timer.start()
	wave_duration_timer.start()

func _on_spawn_timer_timeout() -> void:
	if is_wave_active and current_index < wave_data.size():
		spawn_enemy(wave_data[current_index])
		current_index += 1

func _on_duration_timer_timeout() -> void:
	is_wave_active = false
	spawn_timer.stop()

func spawn_enemy(enemy_info: Dictionary) -> void:
	var enemy_type = enemy_info["type"]
	var enemy_scene: PackedScene = preload("res://scenes/route/Entity_route.tscn")  # contoh default
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
