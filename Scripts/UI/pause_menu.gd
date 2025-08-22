extends Control

# Supaya pause menu tetap aktif walaupun game dipause
@onready var panel_container: PanelContainer = $PanelContainer

func _ready():
	hide()

func _unhandled_input(event):
	if event.is_action_pressed("Escape"):
		if visible:
			resume_game()
		else:
			pause_game()

func pause_game():
	show()
	get_tree().paused = true

func resume_game():
	get_tree().paused = false
	hide()

# --- Tombol ---
func _on_resume_pressed():
	resume_game()

func _on_restart_pressed():
	get_tree().paused = false   # unpause dulu biar reload jalan
	get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().quit()
