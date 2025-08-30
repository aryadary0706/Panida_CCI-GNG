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
	SfxPlayer.play_music(preload("res://audio/click.ogg"))

func resume_game():
	get_tree().paused = false
	SfxPlayer.play_music(preload("res://audio/click.ogg"))
	hide()

# --- Tombol ---
func _on_resume_pressed():
	resume_game()

func _on_restart_pressed():
	get_tree().paused = false   # unpause dulu biar reload jalan
	get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://Objects/MainMenu/main_menu.tscn")
