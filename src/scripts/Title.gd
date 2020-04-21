extends Node2D

func _unhandled_key_input( _event: InputEventKey ) -> void:
	get_tree().change_scene("res://src/scenes/Main.tscn")
