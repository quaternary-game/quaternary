extends Control
var toggle: Button
var trait_menu: Control
var trait_menu_panel: Control
var entity_trait_list: Control
var start_pause_button: Control
var entity_trait_list_item_scene : Resource = preload("res://features/main_game/UI/trait_list/trait_list_item.tscn")
var game_over_scene:PackedScene = preload("res://scenes/guis/end_game.tscn")

var ogmodulate: Color = self.modulate
const TraitDragButton : Resource = preload("res://features/main_game/UI/traits/trait.gd")
signal play(value: bool)
signal trait_drag_start(t: TraitDragButton)
signal trait_drag_end

# should work out something similar to genotype here
@export var TraitList: Array[PackedScene]
@export var TraitListPoints: Array[int]
@export var TotalPoints : int

var tutorial_button: Button

func _ready() -> void:

	MusicPlayer.play_sketching()
	
	start_pause_button = get_node("VBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer2/Start_Pause")
	toggle = get_node("VBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer2/ToggleTraitMenu")
	trait_menu_panel = get_node("VBoxContainer/HBoxContainer/MarginContainer/PanelContainer")
	trait_menu = get_node("VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/TraitMenu")
	trait_menu.traitlist = TraitList
	trait_menu.traitpoints = TraitListPoints
	trait_menu.points = TotalPoints
	trait_menu._ready()
	entity_trait_list = get_node("VBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer2/Traitlist")
	toggle.toggle_mode = true
	for i : Control in trait_menu.traits():
		i.begin_drag.connect(start_drag_button_handler)
		i.end_drag.connect(end_drag_button_handler)
	
	self.tutorial_button = get_node("VBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer2/TutorialButton")

func _on_toggle_trait_menu_toggled(toggled_on: bool) -> void:
	var tween : Tween = create_tween()

	if toggled_on:
		tween.parallel().tween_property(trait_menu_panel, "modulate", ogmodulate, 0.5)
		tween.parallel().tween_property(trait_menu_panel, "scale", Vector2(1,1), 0.5)
	else:
		trait_menu_panel.pivot_offset = trait_menu.get_rect().size
		tween.parallel().tween_property(trait_menu_panel, "modulate", Color(0,0,0,0), 0.5)
		tween.parallel().tween_property(trait_menu_panel, "scale", Vector2(0, 1), 0.5)
	
		
func start_drag_button_handler(data: Variant) -> void:
	trait_drag_start.emit(data)
func end_drag_button_handler(_data: Variant, _success: bool) -> void:
	trait_drag_end.emit()



func _on_start_pause_toggled(toggled_on:bool) -> void:
	play.emit(toggled_on)
	$VBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer2/Timer.paused = not toggled_on



func _on_entitymanager_show_traits(entity: EntityGD) -> void:
	
	for locus: Locus in entity.genotype.get_loci():
		if locus.hidden:
			continue
		
		var l: Control = entity_trait_list_item_scene.instantiate()
		var image_size: int = 30

		var first: bool = true

		for allele: Allele in locus.get_alleles():
			if not is_instance_valid(allele):
				return
			if first:
				l.append_text("[center]%s\n" % GeneticConstants.LocusType.keys()[locus._type])
				first = false
			else:
				l.append_text(":")
			l.add_image(allele.get_trait_instance().icon, image_size, image_size)

		entity_trait_list.add_child(l)
	if "calories" in entity.traits:
		entity_trait_list.add_child(entity.traits["calories"].progress_bar)
	if "age" in entity.traits:
		entity_trait_list.add_child(entity.traits["age"].progress_bar)

func _on_entitymanager_end_show_traits() -> void:
	for i: Node in entity_trait_list.get_children():
		if i is RichTextLabel:
			i.queue_free()
		elif i is TextureProgressBar:
			entity_trait_list.remove_child(i)


func _on_timer_game_over() -> void:
	print_debug("game_over")
	#$EndGame.visible = true
	var game_over_node:Control = game_over_scene.instantiate()
	add_child(game_over_node)
