extends Node2D
class_name WaveManager

@onready var spawn_timer: Timer = $SpawnTimer
@onready var build_phase_timer: Timer = $BuildPhaseTimer
@onready var enemy_container: Node2D = $"../Enemy"
@onready var wave_data: Node = $WaveData
@onready var win_condition: CanvasLayer = $"../WinCondition"

#Signal untuk 
signal build_started
signal build_ended

@export var build_phase_wait_time: float = 10.0
@export var spawn_timer_wait_time: float = 0.5
#signal game_ended

const ENEMY_SCENES := {
	"NT1": preload("res://Objects/Cravers/cravers_normal.tscn"),
	"VT1": preload("res://Objects/Cravers/cravers_vegan.tscn"),
	"GLT": preload("res://Objects/Cravers/cravers_glutton.tscn"),
	"KGR": preload("res://Objects/Cravers/cravers_kangguru_mom.tscn"),
	"NT2": preload("res://Objects/Cravers/cravers_normalT2.tscn"),
	"VT2": preload("res://Objects/Cravers/cravers_veganT2.tscn")
}

# --- STATE ---
var current_wave: int = 0
var max_wave: int
var is_wave_active: bool = false
var is_game_over: bool = false

var spawn_queue : Array = []

func _process(delta: float) -> void:
	check_victory()
	if is_wave_active:
		check_wave_end()

func _ready():
	randomize()
	build_phase_timer.wait_time = build_phase_wait_time
	spawn_timer.wait_time = spawn_timer_wait_time
	max_wave = wave_data.get_wave_data_size()
	start_build_phase()

func start_build_phase():
	is_wave_active = false
	print("Fase Build dimulai. berlangsung selama ", build_phase_timer.wait_time, " s")
	build_phase_timer.start()
	build_started.emit()

func start_wave() -> void:
	var wave = wave_data.get_wave_data(current_wave)
	if wave.is_empty():
		is_game_over = true
		print("Game telah selesai")
		return
	
	spawn_queue.clear()
	
	# Ambil list "enemies"
	for enemy in wave["enemies"]:
		# Ulangi sebanyak "count"
		for i in range(enemy["count"]):
			spawn_queue.append(enemy["type"])
	
	spawn_queue.shuffle()
	current_wave += 1
	spawn_timer.start()
	print("Wave %d: %d musuh" % [current_wave, spawn_queue.size()])


# --- CALLBACKS ---
func _on_spawn_timer_timeout() -> void:
	if spawn_queue.is_empty():
		spawn_timer.stop() # Stop the timer when no more enemies to spawn
		return

	var enemy_type = spawn_queue.pop_front()
	spawn_enemy(enemy_type)


func _on_build_phase_timer_timeout() -> void:
	is_wave_active = true
	print("Build Phase selesai, wave %d dimulai!" % (current_wave + 1))
	build_ended.emit()
	start_wave()

#--Spawn Enemy--

func spawn_enemy(enemy_type: String) -> void:
	if ENEMY_SCENES.has(enemy_type):
		var enemy_scene = ENEMY_SCENES[enemy_type]
		var enemy_instance = enemy_scene.instantiate()
		enemy_container.add_child(enemy_instance)
		SfxPlayer.play_music(preload("res://audio/CraverSpawn.ogg"))
		print("Musuh '", enemy_type, "' berhasil di-spawn.")
	else:
		push_warning("Tipe musuh tidak ditemukan!")

func check_wave_end():
	# Periksa jika spawn_queue kosong DAN jumlah musuh di layar kurang dari 2
	if spawn_queue.is_empty() and enemy_container.get_child_count() <= 4:
		is_wave_active = false
		print("Wave %d selesai! Memulai fase build" % current_wave)
		start_build_phase()

func check_victory():
	if is_game_over and enemy_container.get_child_count() == 0:
		get_parent().get_node("Popup/WinCondition").play_scene()
