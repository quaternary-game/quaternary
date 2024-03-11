extends PanelContainer

@export var base: Globals.NitrogenousBase = Globals.NitrogenousBase.BLANK:
	set(value):
		var details: Dictionary = Globals.NitrogenousBaseDetails[value]
		$Label.text = details.name
		if value != Globals.NitrogenousBase.BLANK:
			tooltip_text = tr(details.long_name)
			print(get_theme_color("Nucleotide", details.name))
			$Label.add_theme_color_override("font_color", get_theme_color(details.name, "Nucleotide"))
		base = value

@export var bg_visible: bool = true:
	set = set_bg_visible

const Mutation = preload("res://features/mutation_minigame/nodes/mutation/mutation.gd")
# Can't use self type for node without using "class_name"
signal mutation(node: Node, mutation: Mutation )

var is_deleted: bool = false
func set_bg_visible(value: bool) -> void:
	if value:
		self.remove_theme_stylebox_override("Panel")
	else:
		self.add_theme_stylebox_override("Panel",StyleBoxEmpty.new())

var nitro_bases :Dictionary = {
	Globals.NitrogenousBase.A: {
		"Tooltip": "Adenine",
		"Color": Color.GREEN,
		"Text": "A"
	},
	Globals.NitrogenousBase.G: {
		"Tooltip": "Adenine",
		"Color": Color.BLUE,
		"Text": "G"
	},
	Globals.NitrogenousBase.T: {
		"Tooltip": "Adenine",
		"Color": Color.RED,
		"Text": "T"
	},
	Globals.NitrogenousBase.C: {
		"Tooltip": "Adenine",
		"Color": Color.ORANGE,
		"Text": "C"
	},

}



func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	if data is Dictionary and get_parent().droppable:
		if (data["Type"] == Globals.Mutation.INSERTION and base == Globals.NitrogenousBase.BLANK):
			return true
		if (data["Type"] == Globals.Mutation.DELETION or data["Type"] == Globals.Mutation.SUBSTITUTION) and base != Globals.NitrogenousBase.BLANK:
			return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	mutation.emit(self, data)

