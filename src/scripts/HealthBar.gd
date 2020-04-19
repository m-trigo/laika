extends AnimatedSprite

func max_health() -> int:
	return len( frames ) - 1

func health() -> int:
	return frame

func heal( amount : int ) -> void:
	frame = max( frame + amount, max_health() ) as int

func damage( amount : int ) -> void:
	frame = max( frame - amount, 0 ) as int
