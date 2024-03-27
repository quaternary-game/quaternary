class_name EntityGD extends CharacterBody2D


# this needs to be configurable with genotype in mind
# so we have a list of "loci"
@export var initial_genotype: Array[Loci] = []

var paused : bool :
	get:
		return process_mode == Node.PROCESS_MODE_DISABLED
	set(value):
		print(traits)
		if value:
			process_mode = Node.PROCESS_MODE_DISABLED
		else:
			process_mode = Node.PROCESS_MODE_INHERIT
		

var traits := {}

## each element should be a list (length 2 = diploid) of traits
## loci should be the key
var genotype := {} 

## each element should be a loci key with some number of traits corresponding to the maximum dominance value
var phenotype := {}

## how many genes in each loci (humans and our creatures are diploid)
## eventually, this should be configurable
var ploidy : int = 2

signal traits_changed

@onready var area: Area2D = $Area 
 
func _ready() -> void:
	for l:Loci in self.initial_genotype:
		for t_index in range(len(l.traits)): 
			self.add_trait(l.traits[t_index], t_index)

var none_scene := preload("res://features/genetics-gd/nodes/entity_traits/trait_none.tscn")
func create_loci(loci: String) -> void:
	genotype[loci] = []
	for i in range(ploidy):
		var none : TraitNone = none_scene.instantiate()
		none.loci = loci
		genotype[loci].append(none)

func add_trait(new_trait: PackedScene, loci_index: int = 0) -> void:
	if new_trait.can_instantiate():
		var _new_trait := new_trait.instantiate()
		_add_trait(_new_trait, loci_index)

func _add_trait(_new_trait: TraitBase, loci_index: int = 0) -> void:
	assert(_new_trait is TraitBase)
	if _new_trait.loci in genotype and _new_trait.unique_trait_name != genotype[_new_trait.loci][loci_index].unique_trait_name:
		genotype[_new_trait.loci][loci_index] = _new_trait
	elif _new_trait.loci not in genotype:
		create_loci(_new_trait.loci)
		genotype[_new_trait.loci][loci_index] = _new_trait
		phenotype[_new_trait.loci] = [] as Array[TraitBase]
		
	var dominant := dominant_trait_at_loci(_new_trait.loci)
	for i:TraitBase in phenotype[_new_trait.loci]:
		if not trait_is_in(i, dominant):
			phenotype[_new_trait.loci].erase(i)
			traits.erase(i.unique_trait_name)
			self.remove_child(i)
			if i not in genotype[_new_trait.loci]:
				i.queue_free()
	for i:TraitBase in dominant:
		if not trait_is_in(i, phenotype[_new_trait.loci]) and not i is TraitNone:
			phenotype[_new_trait.loci].append(i)
			traits[_new_trait.unique_trait_name] = _new_trait
			self.add_child(i)
	traits_changed.emit()

func trait_is_in(t: TraitBase, arr: Array[TraitBase]) -> bool:
		# only unique traits get added to phenotype
	for n : TraitBase in arr:
		if n.unique_trait_name == t.unique_trait_name:
			return true
	return false
	
# this is basically argmax for dominant attribute
func dominant_trait_at_loci(loci: String) -> Array[TraitBase]:
	var dominant: Array[TraitBase] = []
	for i: TraitBase in genotype[loci]:
		if len(dominant) == 0:
			dominant.append(i)
		elif dominant[0].dominance == i.dominance:
			dominant.append(i)
		elif dominant[0].dominance < i.dominance:
			dominant = [i]
	return dominant
	
		
func remove_trait(loci: String, loci_index: int = 0) -> bool:
	if loci not in genotype or loci_index >= ploidy or loci_index < 0:
		return false
	var none := none_scene.instantiate()
	none.loci = loci
	_add_trait(none, loci_index)
	return true


func death() -> void:
	# might want to put a death animation here
	#https://godotshaders.com/shader/transparent-noise-border/
	self.queue_free()
