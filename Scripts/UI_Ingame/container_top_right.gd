extends PanelContainer

@onready var rounds_ongoing: Label = $"MarginContainer/WaveInfo/Wave/Rounds_Ongoing"
@onready var time: Label = $MarginContainer/WaveInfo/Timer/Time
@onready var wave_manager: Node2D =  $"../../WaveManager" as WaveManager


var elapsed_time: float = 0.0

var last_displayed_seconds: int = -1

func _ready() -> void:
	rounds_ongoing.text = str(wave_manager.current_wave) + " / " + str(wave_manager.max_wave)
	time.text = str("00:00")

func _process(delta: float) -> void:
	# update wave info setiap frame
	rounds_ongoing.text = str(wave_manager.current_wave) + " / " + str(wave_manager.max_wave)

	# timer
	elapsed_time += delta
	var current_seconds = int(elapsed_time)
	if current_seconds != last_displayed_seconds:
		var minutes = int(elapsed_time / 60)
		var seconds = int(elapsed_time) % 60
		time.text = "%02d:%02d" % [minutes, seconds]
		last_displayed_seconds = current_seconds
