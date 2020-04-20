extends Node2D

var stop_index : int = 0
var stops : Array = []
func move_car_to_next_stop() -> void:
	stop_index = ( stop_index + 1 ) % len ( stops )
	var anim = $Car/Move.get_animation( "Move" )
	anim.track_set_key_value( 0, 0, $Car.position )
	anim.track_set_key_value( 0, 1, stops[ stop_index ] )
	$Car/Move.play( "Move" )

func _unhandled_key_input( event: InputEventKey ) -> void:
	if event.pressed && event.scancode == KEY_ESCAPE:
		_on_Esc_pressed()
	if event.pressed && event.scancode == KEY_ENTER:
		move_car_to_next_stop()

func _on_Esc_pressed() -> void:
		get_tree().quit()

func _ready() -> void :
	randomize()
	for i in range( 9 ):
		stops.push_back( $Car.position + Vector2.RIGHT * 32 * i )
	for system in $Systems.get_children():
		system.damage( randi() % 4 )
