extends Node3D

@onready var boxes: Array[StaticBody3D] = [
	$Activators/pectoral_fin,
	$Activators/tail_fin,
	$Activators/mouth,
	$Activators/scales,
	$Activators/shape,
	$Activators/ventral_fin,
	$Activators/dorsal_fins
]
var mouse = Vector2()
const DIST = 1000

func _ready() -> void:
	for i in boxes:
		i.get_child(0).visible = false
		i.get_child(1).visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse = event.position
	var hits = get_mouse_world_position(mouse)
	if hits.is_empty() == false:
		var hitted: StaticBody3D
		for i in boxes:
			if i == hits["collider"]:
				hitted = i
				i.get_child(0).visible = true
			else:
				i.get_child(0).visible = false
		if event is InputEventMouseButton:
			if event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
				for i in boxes:
					if i == hitted:
						i.get_child(1).visible = true
					else:
						i.get_child(1).visible = false
	else:
		for i in boxes:
			i.get_child(0).visible = false
		if event is InputEventMouseButton:
			if event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
				for i in boxes:
					i.get_child(1).visible = false
		

func get_mouse_world_position(mouse: Vector2) -> Dictionary:
	var space = get_world_3d().direct_space_state
	var start = get_viewport().get_camera_3d().project_ray_origin(mouse)
	var end = get_viewport().get_camera_3d().project_position(mouse, DIST)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	
	var result = space.intersect_ray(params)
	return result
