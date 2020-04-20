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
		"CATALYC CONVERTED GOT STOLEN.\nITS LOUD AND IT SMELLS FUNNY. YOU OPEN THE WINDOWS.",
		"RUSTED EXHAUST HAS A NEW HOLE.\nYOU TAPE IT AND MOVE ON.",
	],
	"Peripheral": [
		"WINDSHIELD CRACKED.\nLITTLE BY LITTLE THE CRACK WIDENS",
		"TIRES STARTED LEAKING.\nON THE BRIGHT SIDE, LEFT TURNS ARE EASIER.",
		#"BACK BUMPER FELL OFF AND STARTED DRAGGING.\nPOOR BABUSHKA BUMBER STICKERS.",
		"HEADLIGHTS BURNT OFF.\nYOU STOP DRIVING AT NIGHT.",
	]
}
var events_list : Array = []
var event_index : int = 0

enum STATE { MOVING = 0, EVENT, OPTIONS, SYSTEMS, FLAVOR }
var state : int = STATE.MOVING

var options = [
	{
		"name" : "FIX-IT-YOURSELF",
		"effect" : "+1 OR -1 TO ONE SYSTEM",
		"price": 10
	},
	{
		"name" : "REPAIR A SYSTEM",
		"effect" : "+3 TO ONE SYSTEM",
		"price": 30
	},
	{
		"name" : "FULL SYSTEM CHECKUP",
		"effect" : "+1 TO ALL SYSTEMS",
		"price": 50
	}
]

var funds : int = 90

func display_options() -> void:
	var string := "WHAT WILL YOU DO?%56s" % "FUNDS: $%s\n" % funds
	for i in range( len( options ) ):
		var option = options[ i ]
		if option.price > funds:
			string += "\n%s. --- NOT ENOUGH FUNDS ---" % str( i + 1 )
		else:
			var formatted = "{number}. {name}{effect}{price}".format({
				"number" : i + 1,
				"name" : "%-38s" % option.name,
				"effect" : "[%-24s]" % option.effect,
				"price" : "%5s" % "$%d" % option.price
			})
			string += "\n" + formatted
	string += "\n4. HIT THE ROAD. NO TIME TO WASTE!"
	$DialogueBox/Label.text = string

func display_system_options() -> void:
	var string := "WHICH SYSTEM?\n"
	for i in range( len ( events.keys() ) ):
		string += "\n{number}. {system}".format({
			"number": i + 1,
			"system" : events.keys()[ i ].to_upper()
		})
	$DialogueBox/Label.text = string

func display_flavor() -> void:
	$DialogueBox/Label.text = "<FLAVOR TEXT>"
	state = STATE.FLAVOR

var yourself : bool = false
func _unhandled_key_input( event: InputEventKey ) -> void:
	if event.pressed && event.scancode == KEY_ESCAPE:
		_on_Esc_pressed()
	elif event.pressed:
		match state:
			STATE.MOVING:
				return
			STATE.EVENT:
				if event.scancode == KEY_1:
					state = STATE.OPTIONS
					display_options()
			STATE.OPTIONS:
				yourself = false
				match event.scancode:
					KEY_1, KEY_2:
						yourself = event.scancode == KEY_1
						if yourself:
							if funds - 10 < 0:
								return
							funds -= 10
						else:
							if funds - 30 < 0:
								return
							funds -= 30
						display_system_options()
						state = STATE.SYSTEMS
					KEY_3:
						if funds - 50 < 0:
							return
						funds -= 50
						for system in $Systems.get_children():
							system.heal( 1 )
						display_flavor()
					KEY_4:
						display_flavor()
			STATE.SYSTEMS:
				var choice = null
				match event.scancode:
					KEY_1:
						choice = $Systems/Engine
					KEY_2:
						choice = $Systems/Electrical
					KEY_3:
						choice = $Systems/Exhaust
					KEY_4:
						choice = $Systems/Peripheral
				if choice != null:
					if yourself:
						randomize()
						if ( randi() % 2 ) != 0:
							choice.heal( 1 )
						else:
							choice.damage( 1 )
					else:
						choice.heal( 3 )
					display_flavor()
			STATE.FLAVOR:
				state = STATE.MOVING
				var total_health : float = 0
				for system in $Systems.get_children():
					total_health += system.health()
				$Track.move_car_to_next_stop( total_health / 16 )

func _on_Esc_pressed() -> void:
		get_tree().quit()

var deadline : float = 146
var elapsed : float = 0
func _process( _delta : float ) ->void :
	elapsed = $AudioStreamPlayer.get_playback_position()
	$Frame/TimeLeft.value = ( ( deadline - elapsed ) / deadline ) * 100
func _ready() -> void :
	randomize()
	for system in $Systems.get_children():
		system.damage( randi() % 2 + 1 )
	for system in events.keys():
		for event in events[ system ]:
			events_list.push_back( { "system": system, "text" : event } )
	events_list.shuffle()

func _on_Track_arrived() -> void:
	var event = events_list[ event_index ]
	$DialogueBox/Label.text = "YOUR %s" % event.text
	$Systems.get_node( event.system ).damage( 1 )
	event_index = ( event_index + 1 ) % len( events_list )
	$DialogueBox/Label.text += "\n\n1. CONTINUE"
	state = STATE.EVENT
