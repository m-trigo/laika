extends Node2D

signal arrived

func start_movement( dst: Vector2, speed : float ) -> void:
	var ap := $X/Move
	var move := ap.get_animation( "move" ) as Animation
	move.track_set_key_value( 0, 0, $X.position )
	move.track_set_key_value( 0, 1, dst )
	ap.playback_speed = speed
	ap.play( "move" )

func _on_move_animation_finished( _x : String) -> void:
	emit_signal( "arrived" )
