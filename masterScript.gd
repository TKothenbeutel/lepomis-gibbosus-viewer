extends Node3D

@onready var camPivot: Node3D = $Camera
@onready var camFOV: Camera3D = $Camera/Camera3D
@onready var detailedFish: Node3D = $Fish/HighPoly
@onready var myFish: Node3D = $Fish/LowPoly
@onready var aboutMenu: Label = $UI/About

const MOUSE_SENSITIVITY = 0.01
const ZOOM_FACTOR = 0.4
const ZOOM_KEY_FACTOR = 0.6
const ZOOM_MAX = 20
const ZOOM_MIN = 0.01


var camRotate = false
var mouseAboutTab = false
var mouseAboutText = false
var ogAboutPos: float

func _ready() -> void:
	detailedFish.visible = false
	myFish.visible = true
	ogAboutPos = aboutMenu.position.y

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			camRotate = true
		else:
			camRotate = false
	if camRotate and event is InputEventMouseMotion:
		camPivot.rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		camPivot.rotation.y -= event.relative.x * MOUSE_SENSITIVITY
	
	if Input.is_action_just_pressed("zoom_in_key"):
		camFOV.position.z = clamp(camFOV.position.z - ZOOM_KEY_FACTOR, ZOOM_MIN, ZOOM_MAX)
	elif Input.is_action_just_pressed("zoom_out_key"):
		camFOV.position.z = clamp(camFOV.position.z + ZOOM_KEY_FACTOR, ZOOM_MIN, ZOOM_MAX)
	elif Input.is_action_pressed("zoom_in"):
		camFOV.position.z = clamp(camFOV.position.z - ZOOM_FACTOR, ZOOM_MIN, ZOOM_MAX)
	elif Input.is_action_pressed("zoom_out"):
		camFOV.position.z = clamp(camFOV.position.z + ZOOM_FACTOR, ZOOM_MIN, ZOOM_MAX)
		
func _process(delta: float) -> void:
	if mouseAboutTab or mouseAboutText:
		aboutMenu.position.y = lerp(aboutMenu.position.y, 0.0, 0.3)
	else:
		aboutMenu.position.y = lerp(aboutMenu.position.y, ogAboutPos, 0.3)

func switch_fish(toDetailed: bool):
	if toDetailed:
		detailedFish.visible = true
		myFish.visible = false
	else:
		detailedFish.visible = false
		myFish.visible = true

func mouseEventAboutTab():
	mouseAboutTab = not mouseAboutTab

func mouseEventAboutText():
	mouseAboutText = not mouseAboutText


func _on_reset_pressed() -> void:
	get_tree().reload_current_scene()
