extends MarginContainer

@export var menu_screen: HBoxContainer
@export var open_menu: HBoxContainer

@export var open_menu_button: Button
@export var close_menu_button: Button

var toggle_popout_button : Array

func _ready():
	toggle_popout_button = [open_menu_button, close_menu_button]
	
func _process(delta):
	update_button_scale()

func update_button_scale():
	for button in toggle_popout_button:
		button_hov(button, 1.5, 0.2)

func button_hov(button: Button, tween_amt, duration):
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		tween(button, "scale", Vector2.ONE * tween_amt, duration)
	else:
		tween(button, "scale", Vector2.ONE, duration)
		
func tween(button, property, amount, duration):
	var tween = create_tween()
	tween.tween_property(button, property, amount, duration)

func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true

func _on_toggle_menu_pressed():
	toggle_visibility(menu_screen)
	toggle_visibility(open_menu)
