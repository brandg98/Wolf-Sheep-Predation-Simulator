extends Control

var point

var regrowTime = 30
var timeToGrow = 0
var fullyGrown = true

var occupied = false
var index
var adjacent_patches = []

var occupant # = iswolf, issheep, or isgrass

onready var patchRect = get_node("PatchRect")
onready var label = get_node("Label")

func _ready():
	tick()

func tick():
	if occupied:
		label.text = "0"
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
