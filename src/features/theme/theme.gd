extends Theme
## A script to define and set up the global theme
##
## Theme related global constants are defined here, such as colors
## or 
@export_group("Pallete Colors")
@export var bg: Color = Color("283618")
@export var border: Color = Color("dda15e")
@export var A: Color = Color.GREEN
@export var G: Color = Color.BLUE
@export var T: Color = Color.RED
@export var C: Color = Color.ORANGE

## Sets up the global colors, get from any node with get_theme_color(colorname, typename)
func colors():
	set_color("A", "Nucleotide", A)
	set_color("G", "Nucleotide", G)
	set_color("T", "Nucleotide", T)
	set_color("C", "Nucleotide", C)

func modify_stylebox(name: StringName,theme_type: StringName, property: StringName, value: Variant ):
	# needed to avoid lengthy syntax for modification of stylebox properties
	var stylebox = get_stylebox(name, theme_type)
	stylebox.set(property, value)
	set_stylebox(name, theme_type, stylebox)
	

func styleboxes():
	modify_stylebox("panel", "Panel", "bg_color", bg)
	modify_stylebox("panel", "Panel", "border_color", border)

func _init():
	colors()
	styleboxes()
	
	print(get_color_type_list())
	for i in get_color_type_list():
		print("color type %s:%s" % [i, get_color_list(i)])
	for i in get_stylebox_type_list():
		print("stylebox type %s: %s" % [i, get_stylebox_list(i)])
	
