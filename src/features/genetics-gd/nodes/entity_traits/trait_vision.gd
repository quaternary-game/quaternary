class_name TraitVision extends TraitBase

func _ready() -> void:
	initialize()
	$Area2D.body_entered.connect(see_entity)
	$Area2D.body_exited.connect(lost_entity)
	
func _draw() -> void:
	var areascale: Vector2 = $Area2D/Shape.scale/2
	var origin: Vector2 = $Area2D/Shape.polygon[0] 
	var left : Vector2 = $Area2D/Shape.polygon[1] * areascale
	var right : Vector2 = $Area2D/Shape.polygon[-1]
	draw_arc(origin, left.length(), left.angle(), right.angle(), 100, Color(1,1,1,0.05), left.length()*2, true)

var seen_entities: Array[EntityGD] = []

signal seen_entity 

func see_entity(body: Node2D) -> void:
	if body is EntityGD and body != self.entity and body not in seen_entities:
		
		seen_entities.append(body)
		if not body.tree_exiting.is_connected(lost_entity.bind(body)):
			body.tree_exiting.connect(lost_entity.bind(body))
		seen_entity.emit()


func lost_entity(body: Node2D) -> void:
	if body.tree_exited.is_connected(lost_entity.bind(body)):
		body.tree_exiting.disconnect(lost_entity.bind(body))
	if body is EntityGD:
		seen_entities.erase(body)
		
		
func _process(delta: float) -> void:
	rotation = rotate_toward(rotation, self.entity.velocity.angle() + PI/2, delta*2)
