extends KinematicBody2D

var wolfHunger = 20
var hunger = wolfHunger setget set_hunger
var eatGain = 15

var currPatch setget set_currPatch
var currPoint
var speed = 75

var sheepNodeScn = preload("res://Scenes/SheepNode.tscn")

onready var label = get_node("Label")

func set_currPatch(var patch):
	currPatch = patch
	currPoint = patch.point.global_position

func set_hunger(var newHunger):
	if newHunger <= 0:
		currPatch.occupied = 0
		queue_free()
	else:
		hunger = newHunger

func _process(delta):
	var velocity = global_position.direction_to(currPoint) * speed
	
	if global_position.distance_to(currPoint) > 2:
		velocity = move_and_slide(velocity)

func tick():
	move()
	label.text = str(hunger)

func tick1():
	randomize()
	var willEat = randi() % wolfHunger
	if (hunger <= 3 || willEat >= hunger) && edible():
		hunt()
		set_hunger(hunger + eatGain)
	else:
		move()
	
	label.text = str(hunger)

# Wolf will move to random patch nearby
func move(): 
	randomize()
	
	var found = false
	var possible_patches = currPatch.adjacent_patches.duplicate(true)
	possible_patches.shuffle()
	
	while !found && possible_patches.size() != 0:
		if possible_patches[0].occupied != 2:
			found = true
		else:
			possible_patches.remove(0)
	
	if found:
		if possible_patches[0].occupied == 1 && possible_patches[0].occupant != null:
			possible_patches[0].occupant.isEaten()
			set_hunger(hunger + eatGain)
		currPatch.occupied = 0
		set_currPatch(possible_patches[0])
		currPatch.occupied = 2
		
		set_hunger(hunger - 1)

func edible():
	var found = false
	var possible_patches = currPatch.adjacent_patches.duplicate(true)

	while !found && possible_patches.size() != 0:
		if possible_patches[0].occupied == 1 && possible_patches[0].occupant != null:
			found = true
		else:
			possible_patches.remove(0)
	
	return found

func hunt():
	randomize()
	
	var found = false
	var possible_patches = currPatch.adjacent_patches.duplicate(true)
	possible_patches.shuffle()
	
	while !found && possible_patches.size() != 0:
		if possible_patches[0].occupied == 1 && possible_patches[0].occupant != null:
			found = true
		else:
			possible_patches.remove(0)
	
	possible_patches[0].occupant.isEaten()
	
	set_hunger(hunger + eatGain)
