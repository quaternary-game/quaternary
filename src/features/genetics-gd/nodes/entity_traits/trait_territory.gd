extends TraitBase

@export var territory : PackedScene
var territory_instance : Area2D

var speed : float = 60


func _ready() -> void:
	initialize()
	territory_instance = territory.instantiate()
	get_tree().root.add_child(territory_instance)
	territory_instance.global_position = self.entity.global_position

	

func _physics_process(delta: float) -> void:
	if territory_instance not in self.entity.area.get_overlapping_areas():
		var direction: Vector2 = self.entity.global_position.direction_to(territory_instance.global_position)
		self.entity.velocity = direction * speed
	
