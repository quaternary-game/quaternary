extends Control
## Sets offspring choices for the screen after winning

var minigame:bool

func set_choices(offspring_set:Dictionary) -> void:
	for offspring: String in offspring_set.keys():
		$SelectMenu/OptionButton.add_item(offspring)
	
	$SelectMenu/OptionButton.selected = -1


func _on_button_pressed() -> void:
	SceneSwitching.goto_mainmenu()

func _on_next_pressed() -> void:
	if minigame:
		SceneSwitching.restart_scene()
