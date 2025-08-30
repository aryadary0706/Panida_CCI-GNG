extends Node2D

@onready var label: Label = $Label
@onready var build_phase_timer: Timer = $"../BuildPhaseTimer"
@onready var spawn_timer: Timer = $"../SpawnTimer"
@onready var wave_manager: Node2D = $".."

var timer_countdown: Timer
var is_building_phase: bool = false

func _ready() -> void:
	if wave_manager:
		wave_manager.build_started.connect(on_wave_started)
		wave_manager.build_ended.connect(on_wave_ended)
		wave_manager.game_over.connect(on_game_over)

func _process(delta: float) -> void:
	if is_building_phase:
		label.text = "Build Phase: Persiapkan tokomu\nDimulai selama " + str(int(build_phase_timer.time_left) + 1) + " detik!"

func on_wave_started():
	is_building_phase = true
	
func on_wave_ended():
	is_building_phase = false
	label.text = "Wave Phase: Pengunjung sudah mulai datang!"

func on_game_over():
	label.text = "Game telah berakhir (Menang)"
