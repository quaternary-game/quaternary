extends CharacterBody2D

var Traits = []
var SPEED = 80


# this is for determining behavior of cell (our characters)
class State:
	func function():
		pass
	func transition():
		return ""

		
	
class StateMachine:
	var states: Dictionary # {statename: stateobject}
	var current_state: State

	func _init(_states):
		states = _states
		current_state = states[states.keys()[0]]
	func transition():
		current_state.function()
		current_state = states[current_state.transition()]
		
	
func load_trait(trait_name):
	Traits.append(trait_name)
	
func _process(delta):
	pass

class random_direction extends State:
	
	
	var global_node
	
	func _init(global_self):
		global_node = global_self
		
	func function():
		var rng = RandomNumberGenerator.new()
		var new_direction = Vector2(1, 0).rotated(rng.randf() * 2 *PI)
		global_node.velocity = new_direction * global_node.SPEED

	
	func transition():
		return "move random"
		

class move_random extends State:
	var global_node
	var timer = Timer.new()
	var ready: bool = false
	func _init(global_self):
		global_node = global_self
		global_node.add_child(timer)
		timer.set_paused(true)
		timer.set_one_shot(true)
	func function():
		var rng = RandomNumberGenerator.new()
		if timer.is_paused():
			timer.set_paused(false)
			timer.start(rng.randf_range(0.01, 5))
		if timer.is_stopped():
			timer.set_paused(true)
			ready = true
			return
		global_node.move_and_slide()
	func transition():
		if ready:
			ready = false
			return "random direction"
		else:
			return "move random"


var m = StateMachine.new({"random direction":random_direction.new(self), "move random": move_random.new(self)})

func _input(event):
	if Input.is_action_just_pressed("ui_left_click"):
		var camera = get_tree().root.get_node("./Main/Camera")
		camera.node_to_follow = self
		

func _physics_process(delta):
	#m.transition()
	

	
	
	
	
	
