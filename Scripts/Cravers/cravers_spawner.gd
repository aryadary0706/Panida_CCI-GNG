extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var build_phase_timer: Timer = $BuildPhaseTimer
@onready var enemy_container: Node2D = $"../Enemy"
@onready var wave_data: Node = $WaveData
@onready var win_condition: CanvasLayer = $"../WinCondition"



@export var build_phase_wait_time: float = 10.0
@export var spawn_timer_wait_time: float = 0.5
#signal game_ended

const ENEMY_SCENES := {
	"NT1": preload("res://Objects/Cravers/cravers_normal.tscn"),
	"VT1": preload("res://Objects/Cravers/cravers_vegan.tscn"),
	"GLT": preload("res://Objects/Cravers/cravers_glutton.tscn"),
	"KGR": preload("res://Objects/Cravers/cravers_kangguru_mom.tscn"),
	"NT2": preload("res://Objects/Cravers/cravers_normalT2.tscn"),
	"NRU": preload("res://Objects/Cravers/cravers_normal_runner.tscn"),
	"VT2": preload("res://Objects/Cravers/cravers_veganT2.tscn"),
	"VRU": preload("res://Objects/Cravers/cravers_vegan_runner.tscn")
}

# --- STATE ---
var spawn_count: int = 0
var max_enemy : int
var is_wave_active: bool = false
var is_wave_over: bool = false
var current_wave_data: Array
var game_started: bool = false
var current_wave = 0
var max_wave = 0
var current_max_spawn : int
var current_enemy = 0

func _ready():
	randomize()
	build_phase_timer.wait_time = build_phase_wait_time
	spawn_timer.wait_time = spawn_timer_wait_time
	max_enemy = wave_data.get_max_craver_spawn()
	max_wave = wave_data.get_wave_data_size()
	start_build_phase()

func _process(delta: float) -> void:
	check_victory()

func start_build_phase():
	is_wave_over = true
	is_wave_active = false
	print("Fase Build dimulai. berlangsung selama ", build_phase_timer.wait_time, " s")
	build_phase_timer.start()

func start_wave() -> void:
	var wave = wave_data.get_wave_data(current_wave)
	if wave.is_empty():
		emit_signal("game_ended")
		print("Game telah selesai")
		return
	
	spawn_count = 0
	current_max_spawn = 0
	is_wave_active = true
	is_wave_over = false
	current_wave_data.clear()
	
	for troops in wave["enemies"]:
		for i in range(troops["count"]):
			current_wave_data.append(troops["type"])
		current_max_spawn += troops["count"]
	current_wave_data.shuffle()
	current_wave += 1
	spawn_timer.start()
	print("Wave %d dimulai dengan %d musuh!" % [current_wave, current_max_spawn])


# --- CALLBACKS ---
func _on_spawn_timer_timeout() -> void:
	if is_wave_active:
		if spawn_count < current_max_spawn:
			var enemy_type = current_wave_data[spawn_count]
			spawn_enemy(enemy_type)
			spawn_count += 1
			print("Spawn %s (%d/%d)" % [enemy_type, spawn_count, current_max_spawn])
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
		current_enemy += 1
		SfxPlayer.play_music(preload("res://audio/CraverSpawn.ogg"))
		print("Musuh '", enemy_type, "' berhasil di-spawn.")
	else:
		push_warning("Tipe musuh tidak ditemukan!")

func check_victory():
	if not is_wave_active and enemy_container.get_child_count() == 0 and current_wave >= max_wave:
		get_parent().get_node("WinCondition/Win").play_scene()
