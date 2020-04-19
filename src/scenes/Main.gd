extends Node2D

const SYSTEM_MAX : int = 4

var systems = {
	"engine" : 0,
	"electrical" : 0,
	"exhaust" : 0,
	"peripherals" : 0
}

func _unhandled_key_input( event: InputEventKey ) -> void:
	if event.pressed && event.scancode == KEY_ESCAPE:
		_on_Esc_pressed()

func _on_Esc_pressed() -> void:
		get_tree().quit()

func _ready() -> void :
	randomize()
	for system in systems:
		systems[ system ] = randi() % ( SYSTEM_MAX - 1 ) + 2
