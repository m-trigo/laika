extends AnimatedSprite

func max_health() -> int:
	return len( frames ) - 1

func health() -> int:
	return frame

func heal( amount : int ) -> void:
	frame = min( frame + amount, 4 ) as int

func damage( amount : int ) -> void:
	frame = max( frame - amount, 0 ) as int
