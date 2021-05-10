extends KinematicBody2D

var sheepHunger = 10
var hunger = sheepHunger setget set_hunger
var eatGain = 3

var currPatch setget set_currPatch
var currPoint
var speed = 75

onready var label = get_node("Label")

func set_currPatch(var patch):
	currPatch = patch
	currPatch.occupied = 1
	currPatch.occupant = self
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
	randomize()
	var willEat = randi() % sheepHunger
	if (hunger <= 3 || willEat >= hunger) && currPatch.fullyGrown:
		currPatch.eat()
		set_hunger(hunger + eatGain)
	else:
		move()
	
	label.text = str(hunger)

# Sheep will move to random patch nearby
func move(): 
	randomize()
	
	var found = false
	var possible_patches = currPatch.adjacent_patches.duplicate(true)
	possible_patches.shuffle()
	
	while !found && possible_patches.size() != 0:
		if possible_patches[0].occupied == 0:
			found = true
		else:
			possible_patches.remove(0)
	
	if possible_patches.size() != 0:
		currPatch.occupied = 0
		currPatch.occupant = null
		set_currPatch(possible_patches[0])
		currPatch.occupied = 1
		currPatch.occupant = self
		
		set_hunger(hunger - 1)

func isEaten():
		currPatch.occupied = 0
		currPatch.occupant = null
		queue_free()
