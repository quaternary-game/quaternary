extends Button

@export_file var tutorial_scene_path: String = "res://features/tutorial/Tutorial.tscn"
var tutorial_scene: Resource = load(tutorial_scene_path)
var tutorial_instance: Node
# Called when the node entport_file(ers the scene tree for the first time.
func on_button_up() -> void:
	print("hello")
	tutorial_instance.show()

func _ready() -> void:
	tutorial_instance = tutorial_scene.instantiate()
	add_child(tutorial_instance)
	#tutorial_instance.show()
	button_up.connect(on_button_up)
	 # Replace with function body.

