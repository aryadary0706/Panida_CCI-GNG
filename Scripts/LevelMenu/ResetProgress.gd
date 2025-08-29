extends Button

@onready var confirm_dialog = get_node("ConfirmReset")

func _ready():
	
	pressed.connect(_on_reset_button_pressed)
	confirm_dialog.confirmed.connect(_on_confirm_reset_confirmed)

func _on_reset_button_pressed():
	# Munculin popup konfirmasi
	SfxPlayer.play_music(preload("res://audio/click.ogg"))
	confirm_dialog.dialog_text = "Apakah kamu yakin ingin mereset progress?\nTindakan ini tidak bisa dibatalkan."
	confirm_dialog.popup_centered()

func _on_confirm_reset_confirmed():
	# Kalau user klik "OK" baru reset progress
	SfxPlayer.play_music(preload("res://audio/click.ogg"))
	GlobalProgress.reset_progress()
	print("Progress direset.")
