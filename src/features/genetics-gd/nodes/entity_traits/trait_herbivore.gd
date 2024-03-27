class_name TraitHerbivore extends TraitBase
## Defines herbivore-like characteristics.
## This trait has no effect it TraitCalories is not also present on the entity. 
##
## Depends on:
## - TraitCalories
## 
## Entity Properties:
## - None
##
## Customizations:
## - calorie_increment_amount: Integer value to increase the calorie amount by

@export var calorie_increment_amount := 300


func _ready() -> void:
	self.initialize()
	self.entity.area.body_entered.connect(self._on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not (body is FoodHerbivore):
		return
	
	var trait_calories: TraitCalories = self.entity.traits.get("calories")
	if trait_calories == null:
		return
	
	if body.grab_food():
		trait_calories.calories += self.calorie_increment_amount
