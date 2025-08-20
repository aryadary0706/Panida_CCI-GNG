extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var build_phase_timer: Timer = $BuildPhaseTimer
@onready var enemy_container: Node2D = $"../Enemy"
@onready var wave_data: Node = $WaveData

signal game_ended


const ENEMY_SCENES := {
	"normal": preload("res://Objects/Cravers/cravers_normal.tscn"),
	"vegan": preload("res://Objects/Cravers/cravers_vegan.tscn"),
	"glutton": preload("res://Objects/Cravers/cravers_glutton.tscn"),
	"kangguru": preload("res://Objects/Cravers/cravers_kangguru_mom.tscn")
}

# --- STATE ---
var spawn_count: int = 0
var max_enemy : int
var is_wave_active: bool = false
var is_wave_over: bool = false
var current_wave_data: Array
var current_wave = 0
var max_wave = 0

func _ready():
	randomize()
	start_build_phase()

func start_build_phase():
	print("Fase Build dimulai. berlangsung selama ", build_phase_timer.wait_time, " s")
	build_phase_timer.start()

func start_wave() -> void:
	var wave = wave_data.get_wave_data(current_wave)
	if wave.is_empty():
		emit_signal("game_ended")
		print("Game telah selesai")
		return
	
	spawn_count = 0
	is_wave_active = true
	current_wave_data.clear()
	var total_enemies = 0
	
	for troops in wave["enemies"]:
		for i in range(troops["count"]):
			current_wave_data.append(troops["type"])
		total_enemies += troops["count"]
	current_wave_data.shuffle()
	max_enemy = total_enemies
	current_wave += 1
	spawn_timer.start()
	print("Wave %d dimulai dengan %d musuh!" % [current_wave, max_enemy])


# --- CALLBACKS ---
func _on_spawn_timer_timeout() -> void:
	if is_wave_active:
		if spawn_count < max_enemy:
			var enemy_type = current_wave_data[spawn_count]
			spawn_enemy(enemy_type)
			spawn_count += 1
			print("Spawn %s (%d/%d)" % [enemy_type, spawn_count, max_enemy])
		else:
			is_wave_active = false
			spawn_timer.stop()
			print("Semua musuh dalam wave telah di-spawn.")
			start_build_phase()


func _on_build_phase_timer_timeout() -> void:
	print("Fase Build selesai! Wave akan datang!")
	start_wave()

#--Spawn Enemy--

func spawn_enemy(enemy_type: String) -> void:
	if ENEMY_SCENES.has(enemy_type):
		var enemy_scene = ENEMY_SCENES[enemy_type]
		var enemy_instance = enemy_scene.instantiate()
		enemy_container.add_child(enemy_instance)
		print("Musuh '", enemy_type, "' berhasil di-spawn.")
	else:
		push_warning("Tipe musuh tidak ditemukan!")
