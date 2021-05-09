extends Control

const WIDTH = 25
const HEIGHT = 25
const SIZE = 25
const START = 300

var sheepStartNum = 10
var sheepReproduction = 25

onready var patchGrid = get_node("PatchGrid")
onready var pointHolder = get_node("PointHolder")
onready var sheepHolder = get_node("SheepHolder")
onready var wolfHolder = get_node("WolfHolder")

var grassPatchScn = preload("res://Scenes/GrassPatch.tscn")
var patchPointScn = preload("res://Scenes/PatchPoint.tscn")
var sheepNodeScn = preload("res://Scenes/SheepNode.tscn")
var wolfNodeScn = preload("res://Scenes/WolfNode.tscn")

func _ready():
	updateMap()

func updateMap():
	patchGrid.columns = WIDTH
	patchGrid.set("custom_constants/vseparation", 1)
	patchGrid.set("custom_constants/hseparation", 1)
	for c in range(WIDTH * HEIGHT):
		var addPatch = grassPatchScn.instance() # create patch
		addPatch.index = c
		
		var addPoint = patchPointScn.instance() # create patch point
		var x = START + ((c % WIDTH) * SIZE) + 13
		var y = (int(c / WIDTH) * SIZE) + 13
		
		addPatch.point = addPoint # link patch and point
		addPoint.patch = addPatch
		
		patchGrid.add_child(addPatch)
		pointHolder.add_child(addPoint)
		addPoint.global_position = Vector2(x, y)
	
	for p in patchGrid.get_children():
		set_adjacentPatches(p)
	
	# TEST
	#for p in patchGrid.get_child(600).adjacent_patches:
	#	p.eat()
	
	addSheep(sheepStartNum)
	addWolf(10)

func addSheep(var sheepNum):
	for s in range(sheepNum):
		randomize()
		var found = false
		var space
		var newPatch
		while !found:
			space = randi() % (WIDTH * HEIGHT)
			if !patchGrid.get_child(space).occupied:
				newPatch = patchGrid.get_child(space)
				found = true
		
		var newSheep = sheepNodeScn.instance()
		newSheep.currPatch = newPatch
		newPatch.occupied = true
		newPatch.occupant = newSheep
		sheepHolder.add_child(newSheep)
		newSheep.global_position = newSheep.currPoint

func set_adjacentPatches(var patch):
	if patch.index - WIDTH >= 0: # check north patch
		patch.adjacent_patches.append(patchGrid.get_child(patch.index - WIDTH))
	if patch.index + WIDTH < (WIDTH * HEIGHT): # check south patch
		patch.adjacent_patches.append(patchGrid.get_child(patch.index + WIDTH))
	if patch.index % WIDTH != 0: # check west patch
		patch.adjacent_patches.append(patchGrid.get_child(patch.index - 1))
	if patch.index % WIDTH != WIDTH - 1: # check east patch
		patch.adjacent_patches.append(patchGrid.get_child(patch.index + 1))

func _on_TickButton_pressed():
	for s in sheepHolder.get_children():
		s.tick()
	
	for p in patchGrid.get_children():
		p.tick()
	
	for w in wolfHolder.get_children():
		w.tick()
		
		
	reproduceSheep()

func reproduceSheep():
	for sheep in sheepHolder.get_children():
		randomize()
		var willReproduce = randi() % sheepReproduction
		
		if willReproduce == 0:
			var found = false
			var possible_patches = sheep.currPatch.adjacent_patches.duplicate(true)
			possible_patches.shuffle()
			
			while !found && possible_patches.size() != 0:
				if !possible_patches[0].occupied:
					found = true
				else:
					possible_patches.remove(0)
			
			if found:
				var newSheep = sheepNodeScn.instance()
				var newPatch = sheep.currPatch.adjacent_patches.find(possible_patches[0])
				newSheep.currPatch = sheep.currPatch.adjacent_patches[newPatch]
				newSheep.currPatch.occupied = true
				sheepHolder.add_child(newSheep)
				newSheep.global_position = newSheep.currPoint

func addWolf(var sheepNum):
	for s in range(sheepNum):
		randomize()
		var found = false
		var space
		var newPatch
		while !found:
			space = randi() % (WIDTH * HEIGHT)
			if !patchGrid.get_child(space).occupied:
				newPatch = patchGrid.get_child(space)
				found = true
		
		var newWolf = wolfNodeScn.instance()
		newWolf.currPatch = newPatch
		newPatch.occupied = true
		newPatch.occupant = newWolf
		wolfHolder.add_child(newWolf)
		newWolf.global_position = newWolf.currPoint
