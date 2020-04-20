extends Node2D

var stop_index : int = 0
var stops : Array = []

func move_car_to_next_stop() -> void:
	stop_index = ( stop_index + 1 ) % len ( stops )
	var anim = $Car/Move.get_animation( "Move" )
	anim.track_set_key_value( 0, 0, $Car.position )
	anim.track_set_key_value( 0, 1, stops[ stop_index ] )
	$Car/Move.play( "Move" )

func _ready() -> void:
	for i in range( 9 ):
		var pos : Vector2 = $Car.position + Vector2.RIGHT * 32 * i
		stops.push_back( pos )
		var stop : Sprite = Sprite.new()
		stop.texture = preload( "res://assets/sprites/stop.png" )
		stop.centered = false
		stop.position = pos + Vector2.DOWN * 12
		add_child( stop )
