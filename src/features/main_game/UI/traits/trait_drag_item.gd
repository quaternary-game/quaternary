extends Area2D

var Trait : TraitBase
var TraitScene: PackedScene
var button: Control
var droppable  : bool = false
const TraitCircle = preload("res://features/main_game/entitiy_manager/trait_circle.gd")

signal dropped(Self: Area2D)
func emit() -> void:
	if droppable:
		dropped.emit(self)

func _ready() -> void:
	area_entered.connect(area_entered_handler)
	area_exited.connect(area_exited_handler)
	$Sprite2D.texture = Trait.icon

var entered_area : Area2D
func area_entered_handler(area: Area2D) -> void:
	if area is TraitCircle:
		droppable = true

func area_exited_handler(area: Area2D) -> void:
	print(area)
	if area is TraitCircle:
		droppable = false
	
