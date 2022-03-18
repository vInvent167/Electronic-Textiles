extends Spatial

# NOTE: Names of variables: x is actually y and vice versa

onready var shoulder = get_node("Shoulder")
onready var upperArm = get_node("Shoulder/UpperArm")
onready var elbow = get_node("Shoulder/UpperArm/Elbow")
onready var camera = get_node("Camera")
onready var elbowEdit = get_node("ElbowEdit")
onready var shoulderXEdit = get_node("ShoulderXEdit")
onready var shoulderYEdit = get_node("ShoulderYEdit")
onready var shoulderZEdit = get_node("ShoulderZEdit")
onready var elbowSlider = get_node("ElbowSlider")
onready var shoulderXSlider = get_node("ShoulderXSlider")
onready var shoulderYSlider = get_node("ShoulderYSlider")
onready var shoulderZSlider = get_node("ShoulderZSlider")

var prevElbow
var prevShoulderX
var prevShoulderY
var prevShoulderZ

var dictionary : Dictionary
var angles : Array
var page = 0
var path = "res://Angles.json"
export var jsonPath = "res://testJSON/jsonData.json"


# Called when the node enters the scene tree for the first time.
func _ready():
	prevElbow = deg2rad(int(elbowEdit.text))
	prevShoulderX = deg2rad(int(shoulderXEdit.text))
	prevShoulderY = deg2rad(int(shoulderYEdit.text))
	prevShoulderZ = deg2rad(int(shoulderZEdit.text))
	readJSON(path)
	readJSON(jsonPath)


func _process(_delta):
	readJSON(jsonPath)
	dispAngles2()
	
	if Input.is_action_pressed("forward"):
		camera.transform.origin.x -= 0.5
	if Input.is_action_pressed("backward"):
		camera.transform.origin.x += 0.5
	if Input.is_action_pressed("left"):
		camera.transform.origin.z += 0.5
	if Input.is_action_pressed("right"):
		camera.transform.origin.z -= 0.5
	if Input.is_action_pressed("r_left"):
		camera.rotate_y(0.3 /(2 * PI))
	if Input.is_action_pressed("r_right"):
		camera.rotate_y(-0.3 /(2 * PI))
	if Input.is_action_just_pressed("ui_accept"):
		dispAngles()


func toQuat(new_angle : int, axis : Vector3):
	return Quat(axis, deg2rad(new_angle))


func toEuler(new_angle : Quat):
	return new_angle.get_euler()


func readJSON(filepath : String):
	var file = File.new()
	file.open(filepath, file.READ)
	dictionary = parse_json(file.get_as_text())
	angles = dictionary.values()


func dispAngles():
	if page >= angles.size():
		page = 0
	elbowEdit.emit_signal("text_entered", angles[page]["Elbow"])
	shoulderXEdit.emit_signal("text_entered", angles[page]["ShoulderX"])
	shoulderYEdit.emit_signal("text_entered", angles[page]["ShoulderY"])
	shoulderZEdit.emit_signal("text_entered", angles[page]["ShoulderZ"])
	page += 1


func dispAngles2():
	elbowEdit.emit_signal("text_entered", dictionary["angles"][0])
	shoulderXEdit.emit_signal("text_entered", dictionary["angles"][1])
	shoulderYEdit.emit_signal("text_entered", dictionary["angles"][2])
	shoulderZEdit.emit_signal("text_entered", dictionary["angles"][3])


func _on_ElbowEdit_text_entered(new_text):
	var quatAngle = toQuat(int(new_text), Vector3(1, 0, 0))
	var eulerAngle = toEuler(quatAngle)
	elbow.rotate_object_local(Vector3(1, 0, 0), prevElbow)
	elbow.rotate_object_local(Vector3(1, 0, 0), eulerAngle.x)
	prevElbow = -1 * eulerAngle.x
	elbowSlider.value = rad2deg(eulerAngle.x)


func _on_ShoulderXEdit_text_entered(new_text):
	var quatAngle = toQuat(int(new_text), Vector3(-1, 0, 0))
	var eulerAngle = toEuler(quatAngle)
	shoulder.rotate_object_local(Vector3(1, 0, 0), prevShoulderX)
	shoulder.rotate_object_local(Vector3(1, 0, 0), eulerAngle.x)
	prevShoulderX = -1 * eulerAngle.x
	shoulderXSlider.value = -1 * rad2deg(eulerAngle.x)


func _on_ShoulderYEdit_text_entered(new_text):
	var quatAngle = toQuat(int(new_text), Vector3(0, 1, 0))
	var eulerAngle = toEuler(quatAngle)
	shoulder.rotate_object_local(Vector3(0, 1, 0), prevShoulderY)
	shoulder.rotate_object_local(Vector3(0, 1, 0), eulerAngle.y)
	prevShoulderY = -1 * eulerAngle.y
	shoulderYSlider.value = rad2deg(eulerAngle.y)


func _on_ShoulderZEdit_text_entered(new_text):
	var quatAngle = toQuat(int(new_text), Vector3(0, 0, 1))
	var eulerAngle = toEuler(quatAngle)
	shoulder.rotate_object_local(Vector3(0, 0, 1), prevShoulderZ)
	shoulder.rotate_object_local(Vector3(0, 0, 1), eulerAngle.z)
	prevShoulderZ = -1 * eulerAngle.z
	shoulderZSlider.value = rad2deg(eulerAngle.z)


func _on_ElbowSlider_value_changed(value):
	var quatAngle = toQuat(value, Vector3(1, 0, 0))
	var eulerAngle = toEuler(quatAngle)
	elbow.rotate_object_local(Vector3(1, 0, 0), prevElbow)
	elbow.rotate_object_local(Vector3(1, 0, 0), eulerAngle.x)
	prevElbow = -1 * eulerAngle.x
	elbowEdit.text = String(round(rad2deg(eulerAngle.x)))


func _on_ShoulderXSlider_value_changed(value):
	var quatAngle = toQuat(value, Vector3(-1, 0, 0))
	var eulerAngle = toEuler(quatAngle)
	shoulder.rotate_object_local(Vector3(1, 0, 0), prevShoulderX)
	shoulder.rotate_object_local(Vector3(1, 0, 0), eulerAngle.x)
	prevShoulderX = -1 * eulerAngle.x
	shoulderXEdit.text = String(-1 * round(rad2deg(eulerAngle.x)))


func _on_ShoulderYSlider_value_changed(value):
	var quatAngle = toQuat(value, Vector3(0, 1, 0))
	var eulerAngle = toEuler(quatAngle)
	shoulder.rotate_object_local(Vector3(0, 1, 0), prevShoulderY)
	shoulder.rotate_object_local(Vector3(0, 1, 0), eulerAngle.y)
	prevShoulderY = -1 * eulerAngle.y
	shoulderYEdit.text = String(round(rad2deg(eulerAngle.y)))


func _on_ShoulderZSlider_value_changed(value):
	var quatAngle = toQuat(value, Vector3(0, 0, 1))
	var eulerAngle = toEuler(quatAngle)
	shoulder.rotate_object_local(Vector3(0, 0, 1), prevShoulderZ)
	shoulder.rotate_object_local(Vector3(0, 0, 1), eulerAngle.z)
	prevShoulderZ = -1 * eulerAngle.z
	shoulderZEdit.text = String(round(rad2deg(eulerAngle.z)))
