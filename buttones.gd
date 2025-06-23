extends ColorRect

@onready var selectSeat=$"."
@onready var seatDetector=$"../Area3D"
@onready var student=$".."
@onready var camera=$"../Camera"
func _ready() -> void:
	selectSeat.visible=camera.is_multiplayer_authority()

func _on_button_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-11.69,1.519,10.963)
	seatDetector.monitorable=true
	student.global_position=Vector3(-11.69,1.519,10.963)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _on_button_2_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-11.69,1.519,6.952)
	seatDetector.monitorable=true
	student.global_position=Vector3(-11.69,1.519,6.952)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _on_button_3_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-8.021,2.575,10.963)
	seatDetector.monitorable=true
	student.global_position=Vector3(-8.021,2.575,10.963)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _on_button_4_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-8.021,2.575,6.952)
	seatDetector.monitorable=true
	student.global_position=Vector3(-8.021,2.575,6.952)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_5_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-4.371,3.54,10.963)
	seatDetector.monitorable=true
	student.global_position=Vector3(-4.371,3.54,10.963)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_6_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-4.371,3.54,6.952)
	seatDetector.monitorable=true
	student.global_position=Vector3(-4.371,3.54,6.952)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _on_button_7_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(6.147,2.575,10.963)
	seatDetector.monitorable=true
	student.global_position=Vector3(6.147,2.575,10.963)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_8_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(6.147,2.575,6.952)
	seatDetector.monitorable=true
	student.global_position=Vector3(6.147,2.575,6.952)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	
func _on_button_9_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(9.821,3.54,10.963)
	seatDetector.monitorable=true
	student.global_position=Vector3(9.821,3.54,10.963)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_10_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(9.821,3.54,6.952)
	seatDetector.monitorable=true
	student.global_position=Vector3(9.821,3.54,6.952)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	
func _on_button_11_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(13.471,4.657,10.963)
	seatDetector.monitorable=true
	student.global_position=Vector3(13.471,4.657,10.963)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_12_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(13.471,4.657,6.952)
	seatDetector.monitorable=true
	student.global_position=Vector3(13.471,4.657,6.952)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_13_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-11.69,1.519,-6.661)
	seatDetector.monitorable=true
	student.global_position=Vector3(-11.69,1.519,-6.661)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _on_button_14_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-11.69,1.519,-10.672)
	seatDetector.monitorable=true
	student.global_position=Vector3(-11.69,1.519,-10.672)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _on_button_15_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-8.021,2.575,-6.661)
	seatDetector.monitorable=true
	student.global_position=Vector3(-8.021,2.575,-6.661)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _on_button_16_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-8.021,2.575,-10.672)
	seatDetector.monitorable=true
	student.global_position=Vector3(-8.021,2.575,-10.672)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_17_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-4.371,3.54,-6.661)
	seatDetector.monitorable=true
	student.global_position=Vector3(-4.371,3.54,-6.661)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_18_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(-4.371,3.54,-10.672)
	seatDetector.monitorable=true
	student.global_position=Vector3(-4.371,3.54,-10.672)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _on_button_19_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(6.147,2.575,-6.661)
	seatDetector.monitorable=true
	student.global_position=Vector3(6.147,2.575,-6.661)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_20_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(6.147,2.575,-10.672)
	seatDetector.monitorable=true
	student.global_position=Vector3(6.147,2.575,-10.672)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	
func _on_button_21_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(9.821,3.54,-6.661)
	seatDetector.monitorable=true
	student.global_position=Vector3(9.821,3.54,-6.661)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_22_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(9.821,3.54,-10.672)
	seatDetector.monitorable=true
	student.global_position=Vector3(9.821,3.54,-10.672)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	
func _on_button_23_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(13.471,4.657,-6.661)
	seatDetector.monitorable=true
	student.global_position=Vector3(13.471,4.657,-6.661)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _on_button_24_pressed() -> void:
	if !camera.is_multiplayer_authority():
		return
	seatDetector.global_position=Vector3(13.471,4.657,-10.672)
	seatDetector.monitorable=true
	student.global_position=Vector3(13.471,4.657,-10.672)
	student.rotation_degrees.y=-90.0
	camera.updateStudentPosition()
	selectSeat.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
