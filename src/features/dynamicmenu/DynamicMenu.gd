class_name DynamicMenu extends Control
## A menu that can animate the appearance and dissapearance of control nodes
##
## extend this class on top of a box or grid container for automatic spacing

## Animate the reveal of a child of the dynamic menu
func reveal_slide_child(node: Control) -> void:
	var spacer := Control.new()
	# set this if you want a min size for the spacer
	#spacer.custom_minimum_size = Vector2(1,1)
	self.add_child(spacer)
	self.move_child(spacer, node.get_index())
	var tween: Tween = create_tween()

	var min_size: Vector2 = node.get_minimum_size()
	if node.custom_minimum_size != Vector2(0,0):
		min_size = node.custom_minimum_size
	tween.tween_property(spacer, "custom_minimum_size",min_size, 0.2)
	var spacer_finished: Callable = func() -> void:
		self.remove_child(spacer)
		node.visible = true
	tween.connect("finished", spacer_finished)

## Animate the dissapearance of a child of the dynamic menu
func hide_slide_child(node: Control) -> void:
	var spacer : Control = Control.new()
	spacer.custom_minimum_size = node.size
	self.add_child(spacer)
	self.move_child(spacer, node.get_index())
	node.visible = false
	var tween: Tween = create_tween()
	tween.tween_property(spacer, "custom_minimum_size", Vector2(0,0), 0.2)
	var spacer_finished: Callable = func() -> void:
		self.remove_child(spacer)
	tween.connect("finished", spacer_finished)
