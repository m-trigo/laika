extends Node2D

signal updated

func total_health() -> int:
	var total : int = 0
	for system in get_children():
		total += system.health()
	return total

func _on_Engine_health_updated() -> void:
	emit_signal( "updated" )

func _on_Electrical_health_updated() -> void:
	emit_signal( "updated" )

func _on_Exhaust_health_updated() -> void:
	emit_signal( "updated" )

func _on_Peripheral_health_updated() -> void:
	emit_signal( "updated" )
