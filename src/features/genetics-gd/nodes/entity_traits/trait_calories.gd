class_name TraitCalories extends TraitBase
## Defines basic hunger characteristics
## 
## Entity Properties:
## - calories: An integer count that represents the number of calories the entity has
##
## Customizations:
## - decay_enabled: Boolean value to indicate if decay should occur
## - decay_rate_sec: Float number of seconds that defines the rate at which calories decay
## - calorie_decay_amount: Integer number that defines the quantity of calories to decay



# ################### #
#  Entity Properties  #
# ################### #

## An integer count that represents the number of calories the entity has
@export var calories := 2000:
	set(value):
		calories = value
		if calories <= 0:
			self.queue_free()



# ##################### #
#  Trait Customization  #
# ##################### #

## Boolean value to indicate if decay should occur
@export var decay_enabled : bool :
	get:
		return not $DecayTimer.paused
	set(value):
		var new_value := not value
		
		if $DecayTimer:
			$DecayTimer.paused = new_value
		else:
			self._deferred_enabled = new_value

## Float number of seconds that defines the rate at which calories decay
@export var decay_rate_sec : float :
	get:
		return $DecayTimer.wait_time
	set(value):
		if $DecayTimer:
			$DecayTimer.wait_time = value
		else:
			self._deferred_decay_rate_sec = value

## Integer number that defines the quantity of calories to decay
@export var calorie_decay_amount := 25

var _deferred_enabled: bool
var _deferred_decay_rate_sec: float



# ###################### #
#  Trait Behavior Logic  #
# ###################### #

func _ready() -> void:
	self.initialize()
	$DecayTimer.paused = self._deferred_enabled
	$DecayTimer.wait_time = self._deferred_decay_rate_sec

func _process(_delta: float) -> void:
	$DebugLabel.text = str(self.calories)

func _on_decay_timer_timeout() -> void:
	self.calories -= self.calorie_decay_amount
