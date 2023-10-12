extends Node2D




var LeftStartPosition
var RightStartPosition

func _ready():
	LeftStartPosition = $LeftPupil.position
	RightStartPosition = $RightPupil.position

func look_toward_mouse(node, startposition, time: float =0.1):
	var tween = create_tween()
	var mouse_pos = node.get_local_mouse_position()
	var direction = Vector2.ZERO.direction_to(mouse_pos)
	var dist = mouse_pos.length()
	tween.tween_property(node, "position", direction * min(dist, 30) + startposition, time)
	
func look_toward_node(node, startposition, goal_node):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_toward_mouse($LeftPupil, LeftStartPosition)
	look_toward_mouse($RightPupil, RightStartPosition)
	
