class_name TraitAge extends TraitBase


@export var max_age : float = 60

var timer : Timer = Timer.new()

var age : float:
	get:
		return max_age - timer.time_left
		
func _ready() -> void:
	timer.wait_time = max_age
	timer.one_shot
	timer.start()
	timer.timeout.connect(self.entity.death)
	
	
