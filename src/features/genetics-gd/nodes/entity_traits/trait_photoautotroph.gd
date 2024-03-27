class_name TraitPhotoautotroph extends TraitBase
## Defines photoautotroph-like characteristics (the entity photosynthesizes).
## This trait has no effect it TraitCalories is not also present on the entity. 
##
## Depends on:
## - TraitCalories
## 
## Entity Properties:
## - None
##
## Customizations:
## - calorie_increment_amount: Integer value to increase the calorie amount by.
##   - This number is multiplied by the intensity of the light body
## - increment_rate_sec: Float number of seconds that defines the rate at which calories increase

@export var calorie_increment_amount := 300

## Float number of seconds that defines the rate at which calories decay
@export var increment_rate_sec : float :
	get:
		return $Increment_timer.wait_time
	set(value):
		if $Increment_timer:
			$Increment_timer.wait_time = value
		else:
			self._deferred_increment_rate_sec = value

var _deferred_increment_rate_sec: float

var _light_bodies: Dictionary = {}

func _ready() -> void:
	self.initialize()
	self.increment_rate_sec = self._deferred_increment_rate_sec
	self.entity.area.body_entered.connect(self._on_body_entered)
	self.entity.area.body_exited.connect(self._on_body_exited)

func _on_body_entered(body: Node) -> void:
	if not (body is LightDirected):
		return
	
	self._light_bodies[body.get_instance_id()] = body
	$IncrementTimer.paused = false
	if $IncrementTimer.is_stopped():
		$IncrementTimer.start()

func _on_body_exited(body: Node) -> void:
	if not (body is LightDirected):
		return
	
	self._light_bodies.erase(body.get_instance_id())
	
	if self._light_bodies.is_empty():
		$IncrementTimer.paused = true


func _on_increment_timer_timeout() -> void:
	var trait_calories: TraitCalories = self.entity.traits.get("calories")
	if trait_calories == null:
		return
	
	for body: LightDirected in self._light_bodies.values():
		trait_calories.calories += self.calorie_increment_amount * body.intensity
