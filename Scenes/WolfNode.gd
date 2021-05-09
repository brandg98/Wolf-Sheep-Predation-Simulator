extends KinematicBody2D

var wolfHunger = 10
var hunger = wolfHunger setget set_hunger
var eatGain = 9

var currPatch setget set_currPatch
var currPoint
var speed = 75

var pablo = "wolf"

var sheepNodeScn = preload("res://Scenes/SheepNode.tscn")

#
func set_currPatch(var patch):
	currPatch = patch
	currPoint = patch.point.global_position

func set_hunger(var newHunger):
	if newHunger <= 0:
		currPatch.occupied = false
		queue_free()
	elif newHunger > wolfHunger:
		hunger = wolfHunger
	else:
		hunger = newHunger

func _process(delta):
	var velocity = global_position.direction_to(currPoint) * speed
	
	if global_position.distance_to(currPoint) > 2:
		velocity = move_and_slide(velocity)

func tick():
	randomize()
	var willEat = randi() % wolfHunger
	var prey = edible()
	if (hunger <= 3 || willEat >= hunger) && (prey != false):
		hunt(prey)
		set_hunger(hunger + eatGain)
	else:
		move()
	

# Sheep will move to random patch nearby
func move(): 
	randomize()
	
	var found = false
	var possible_patches = currPatch.adjacent_patches.duplicate(true)
	possible_patches.shuffle()
	
	while !found && possible_patches.size() != 0:
		if !possible_patches[0].occupied:
			found = true
		else:
			possible_patches.remove(0)
	
	if possible_patches.size() != 0:
		currPatch.occupied = false
		set_currPatch(possible_patches[0])
		currPatch.occupied = true
		currPatch.occupant = self
		
		set_hunger(hunger - 1)
		
		
func edible(): 
	randomize()
	
	var found = false
	var possible_patches = currPatch.adjacent_patches.duplicate(true)
	possible_patches.shuffle()

	while !found && possible_patches.size() != 0:
		if possible_patches[0].occupied:
			if possible_patches[0].occupant.pablo == "sheep":
				found = true
				
		else:
			possible_patches.remove(0)
	
	if found:
		return possible_patches[0]
	else:
		return false
	if possible_patches.size() != 0:
		currPatch.occupied = false
		set_currPatch(possible_patches[0])
		currPatch.occupied = true
		
		set_hunger(hunger - 1)
		
func hunt(var isSheep):
		isSheep.occupant.isEaten()
		currPatch.occupied = false
		set_currPatch(isSheep)
		currPatch.occupied = true
		
		set_hunger(hunger + eatGain)
