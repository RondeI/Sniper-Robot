extends Node3D

const examinatorScene=preload("res://player.tscn")
const studentScene=preload("res://student_player.tscn")
@onready var nosyStudent=preload("res://nosy_student.tscn")
@onready var serverButtons=$CanvasLayer
@onready var ipAddress=$CanvasLayer/LineEdit
@onready var ipAnimation=$CanvasLayer/AnimationPlayer2
@onready var endingMsg=$RichTextLabel
@onready var reloadTimer=$ReloadTimer
var peer=ENetMultiplayerPeer.new()
var isElectricityOn:bool=true

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ESC"):
		get_tree().quit()
	if Input.is_action_just_pressed("Show Cursor"):	
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("Hide Cursor"):	
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


@rpc("any_peer","call_local")
func synchronizeElectricity(elec:bool):
	isElectricityOn=elec

func setElectricity(elec:bool):
	isElectricityOn=elec
	synchronizeElectricity.rpc(isElectricityOn)


func add_examinator(pid):
	var examinator=examinatorScene.instantiate()
	examinator.name=str(pid)
	call_deferred("add_child",examinator)

func add_student(pid):
	var student=studentScene.instantiate()
	student.name=str(pid)
	student.position=Vector3(0,-100,0)
	call_deferred("add_child",student)

func exit_game(pid):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(pid)

func del_player(pid):
	rpc("_del_player",pid)
@rpc("any_peer","call_local")
func _del_player(pid):
	get_node(str(pid)).queue_free()

@rpc("any_peer","call_local")
func create_child(pos:Vector3):
	var nosy=nosyStudent.instantiate()
	nosy.name="nosyStudent"
	nosy.position=pos
	add_child(nosy)

func _on_host_pressed() -> void:
	peer=ENetMultiplayerPeer.new() 
	await get_tree().create_timer(0.1).timeout
	peer.create_server(25565)
	multiplayer.multiplayer_peer=peer
	multiplayer.server_relay = true
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer: "+ str(pid)+" has joined the game")
			add_student(pid)
	)
	add_examinator(multiplayer.get_unique_id())
	print("Server hosted sucesfully! :DDDdD")
	serverButtons.hide() 

@rpc("any_peer","call_local") 
func showMsgToAll(msg) -> void:
	endingMsg.visible=true
	reloadTimer.start()
	endingMsg.text="[font size=150][color=FF0808]"+msg


func showMsg(msg:String):
	endingMsg.visible=true
	endingMsg.text="[font size=150][color=FF0808]"+msg
	reloadTimer.start()
	showMsgToAll.rpc(msg)

func isValidIp(ip: String) -> bool:
	if ip=="":
		ip="127.0.0.1"
		return true
	if ip == "127.0.0.1" or ip=="localhost":
		return true
	var parts = ip.split(".")
	if parts.size() != 4:
		return false
	for part in parts:
		if not part.is_valid_int() or int(part) < 0 or int(part) > 255:
			return false
	return true

func _on_join_pressed() -> void:
	var ip = ipAddress.text
	if not isValidIp(ip):
		ipAnimation.play("invalid")
		return 
		
	peer.create_client(ip, 25565)
	multiplayer.multiplayer_peer=peer
	serverButtons.hide()


func _on_peer_connected(id: int):
	if multiplayer.get_peers().size() > 1:
		print("Server full! Rejecting peer ", id)
		multiplayer.multiplayer_peer.disconnect_peer(id)



func _on_peer_disconnected(id: int):
	print("Player disconnected: ", id)
	if multiplayer.get_peers().size() == 0:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().reload_current_scene()

func _on_reload_timer_timeout() -> void:
	if multiplayer.has_multiplayer_peer():
		if multiplayer.is_server():
			peer.close()
			await get_tree().create_timer(0.3).timeout
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	get_tree().reload_current_scene()
