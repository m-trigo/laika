extends Node2D

signal arrived

var stop_index : int = 0
var stops : Array = []

func move_car_to_next_stop( speed : float ) -> void:
	stop_index = ( stop_index + 1 ) % len ( stops )
	var anim = $Car/Move.get_animation( "Move" )
	anim.track_set_key_value( 0, 0, $Car.position )
	anim.track_set_key_value( 0, 1, stops[ stop_index ] )
	$Car/Move.playback_speed = speed
	print ( $Car/Move.playback_speed )
	$Car/Move.play( "Move" )

func _ready() -> void:
	for i in range( 9 ):
		var pos : Vector2 = Vector2( 24, 80 ) + Vector2.RIGHT * 32 * i
		stops.push_back( pos )
		var stop : Sprite = Sprite.new()
		stop.texture = preload( "res://assets/sprites/stop.png" )
		stop.centered = false
		stop.position = pos + Vector2.DOWN * 12
		add_child( stop )

func _on_Move_animation_finished( _anim_name: String ) -> void:
	emit_signal( "arrived" )
