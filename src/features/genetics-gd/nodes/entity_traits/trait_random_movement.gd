extends TraitBase

@export var direction := Vector2(1, 0)
@export var speed := 60

var rng := RandomNumberGenerator.new()
var screen_size: Vector2

func _ready()-> void:
	self.initialize()
	rng.randomize()
	screen_size = get_viewport_rect().size
	change_direction()

func change_direction() -> void:
	var new_direction := Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1))
	self.direction = new_direction.normalized()
	self.entity.velocity = self.direction * self.speed

func _physics_process(delta: float) -> void:
	var should_change: bool = rng.randi_range(0, 120) == 30
	
	if should_change:
		change_direction()

	self.entity.move_and_slide()
	self.entity.position = self.entity.position.clamp(Vector2.ZERO, screen_size)
