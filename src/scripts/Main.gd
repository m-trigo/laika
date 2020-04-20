extends Node2D

var events := {
	"Engine": [
		"ENGINE STARTED SPUTTERING.\nBUT YOU MADE IT TO THE NEXT STOP.",
		#"ENGINE IS OVERHEATING.\nYOU TELL YOURSELF: \"SLOW AND STEADY WINS THE RACE\".",
		"RADIATOR IS LEAKING.\nYOU TOP IT OFF WITH VODKA.",
		"HEAD GASKET IS LEAKING.\nTHE POOL OF OIL LOOKS LIKE BABUSHKA."
	],
	"Electrical": [
		"BATTERY STARTED DYING.\nYOU SILENTLY PRAY WHEN TURNING THE KEY.",
		"SPARK PLUGS HAVE WORN OUT.\nYOU AVOID GOING UPHILL.",
		#"ALTERNATOR STOPPED WORKING.\nYOU TURN OFF THE RADIO TO SAVE BATTERY.",
		"WIPERS ARE ALWAYS ON. YOU CANT TURN THEM OFF.\nIT WILL RAIN EVENTUALLY."
	],
	"Exhaust": [
		"MUFFLER FELL OFF.\nYOU TURN UP THE RADIO.",
		"CATALYC CONVERTED GOT STOLEN.\nIT SMELLS FUNNY. YOU OPEN THE WINDOWS.",
		"RUSTED EXHAUST HAS A NEW HOLE.\nYOU TAPE IT AND MOVE ON.",
	],
	"Peripheral": [
		"WINDSHIELD CRACKED.\nLITTLE BY LITTLE THE CRACK WIDENS",
		"TIRES STARTED LEAKING.\nON THE BRIGHT SIDE, LEFT TURNS ARE NOW EASIER.",
		#"BACK BUMPER FELL OFF AND STARTED DRAGGING.\nPOOR BABUSHKA BUMBER STICKERS.",
		"HEADLIGHTS BURNT OFF.\nYOU STOP DRIVING AT NIGHT.",
	]
}
var events_list : Array = []
var event_index : int = 0

func _unhandled_key_input( event: InputEventKey ) -> void:
	if event.pressed && event.scancode == KEY_ESCAPE:
		_on_Esc_pressed()
	if event.pressed && event.scancode == KEY_ENTER:
		var total_health : float = 0
		for system in $Systems.get_children():
			total_health += system.health()
		$Track.move_car_to_next_stop( total_health / 16 )

func _on_Esc_pressed() -> void:
		get_tree().quit()

func _ready() -> void :
	randomize()
	for system in $Systems.get_children():
		system.damage( 2 )
	for system in events.keys():
		for event in events[ system ]:
			events_list.push_back( { "system": system, "text" : event } )
	events_list.shuffle()

func _on_Track_arrived() -> void:
	var event = events_list[ event_index ]
	$DialogueBox/Label.text = "YOUR %s" % event.text
	$Systems.get_node( event.system ).damage( 1 )
	event_index = ( event_index + 1 ) % len( events_list )
