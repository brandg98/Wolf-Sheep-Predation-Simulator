extends Control

var point

var regrowTime = 30
var timeToGrow = 0
var fullyGrown = true

var occupied = 0
var occupant = null
var index
var adjacent_patches = []

onready var patchRect = get_node("PatchRect")
onready var label = get_node("Label")

func _ready():
	tick()

func tick():
	if occupied == 2:
		label.text = ""
	elif occupied == 1:
		label.text = ""
	else:
		label.text = ""
	
	if timeToGrow > 0:
		timeToGrow -= 1
		fullyGrown = false
	else:
		fullyGrown = true
	
	if fullyGrown:
		patchRect.color = Color.forestgreen
	else:
		patchRect.color = Color.darkgoldenrod

func eat():
	if fullyGrown:
		fullyGrown = false
		timeToGrow = regrowTime
		return true
	else:
		return false
