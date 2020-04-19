extends Node2D

func _unhandled_key_input( event: InputEventKey ) -> void:
	if event.pressed && event.scancode == KEY_ESCAPE:
		_on_Esc_pressed()

func _on_Esc_pressed() -> void:
		get_tree().quit()

func _ready() -> void :
	randomize()
	for system in $Systems.get_children():
		system.damage( randi() % 4 )
