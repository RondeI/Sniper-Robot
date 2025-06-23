extends Node3D

var mouseMotion =Vector2.ZERO
var DPI:int=6
var minigameActive:bool=false
var inArea:bool=false
var animationActive:bool=false
var minigameMode:bool=false
var createCheckOnce:bool=true
@onready var camera=$Neck/Camera3D
@onready var cameraPivot=$Neck
@onready var tutorialText=$RichTextLabel
@onready var hitBar=$TextureRect
@onready var correctBar=$TextureRect2
@onready var hitBarArea=$TextureRect/Area2D
@onready var cursor=$TextureRect3
@onready var cardAnimation=$AnimationPlayer
@onready var phone=$"../Sprite3D3"
@onready var cheatText=$RichTextLabel2
@onready var cheatSheet=$"../Sprite3D"
@onready var penaltyTimer=$"../PenaltyTimer"
@onready var penaltyAnimation=$"../AnimationPlayer2"
@onready var cheatingBar=$TextureRect2/ProgressBar
@onready var phoneLight=$"../Sprite3D3/SpotLight3D"
@onready var pressText=$RichTextLabel3
@onready var selectSeat=$"../ColorRect"
@onready var seatDetector=$"../Area3D"
@onready var student=$".."
@onready var studentBody=$"../studentPlayer"
@onready var studentColShape=$"../studentPlayer/CollisionShape3D"
@onready var seatCheck=preload("res://seat_check.tscn")
@onready var checks=$"../checks"
@onready var minigameProgress=$"../MinigameProgress"
@onready var minigameLabel=$"../MinigameProgress/RichTextLabel2"
@onready var minigameLabel2=$"../MinigameProgress/RichTextLabel3"
@onready var abilities=$"../Abilities"
@onready var ability1=$"../Abilities/TextureRect"
@onready var ability2=$"../Abilities/TextureRect2"
@onready var nosyStudent=preload("res://nosy_student.tscn")
var randomizedKey:String=""


@rpc("any_peer")
func sync_card_position(pos: Vector3):
	cheatSheet.position = pos


@rpc("any_peer")
func sync_phone_position(pos: Vector3,visibility:bool):
	phone.position = pos
	phoneLight.visible = visibility

@rpc("any_peer")
func sync_student_position(pos:Vector3,rotationD:Vector3):
	student.global_position=pos
	studentBody.global_position=pos
	studentColShape.global_position=pos
	student.rotation_degrees=rotationD

@rpc("any_peer")
func sync_progress_visiblity(vis:bool):
	minigameProgress.visible=vis


@rpc("any_peer")
func sync_minigame_label(text):
	minigameLabel.text=text

func updateStudentPosition():
	sync_student_position.rpc(student.global_position,student.rotation_degrees)
	

func syncVisiblity():
	sync_progress_visiblity.rpc(minigameProgress.visible)

func syncPos():
	sync_card_position.rpc(cheatSheet.position)

func syncPos2():
	sync_phone_position.rpc(phone.position,phoneLight.visible)


func _enter_tree() -> void:
	set_multiplayer_authority(get_parent().name.to_int())

func _ready() -> void:
	tutorialText.text="[outline_size=4][outline_color=080808][font size=24]PRESS [color=11FF00]E[/color] TO CHEAT ON THE TEST!!1!"
	if is_multiplayer_authority():
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	cheatText.visible=false
	hitBar.visible=false
	cursor.visible=false
	correctBar.visible=false
	pressText.visible=false
	tutorialText.visible=is_multiplayer_authority()
	camera.current=is_multiplayer_authority()

func _process(_delta: float) -> void:
	if !multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer == null:
		return
	if !is_multiplayer_authority():
		return
	if multiplayer.get_peers().size()==1 and not minigameProgress.visible and not selectSeat.visible:
		minigameProgress.visible=true
		ability1.visible=true
		ability2.visible=true
		syncVisiblity()

func _physics_process(_delta: float) -> void:
	if !multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer != null:
		return
	if !is_multiplayer_authority():
		return
	cameraRotation()
	if selectSeat.visible:
		syncButtons()
	if animationActive:
		if minigameMode:
			syncPos2()
		else:
			syncPos()


func _input(event):
	if !multiplayer.has_multiplayer_peer():
		return
	if !is_multiplayer_authority():
		return
	mouse(event)
	ability()
	minigame()
	if Input.is_action_just_pressed("ESC"):
		get_parent().get_parent().exit_game(get_parent().name.to_int())

func ability():
	if Input.is_action_just_pressed("Ability1") and abilities.visible and not selectSeat.visible:
		get_parent().get_parent().setElectricity(false)
		abilities.visible=false
	if Input.is_action_just_pressed("Ability2") and abilities.visible and not selectSeat.visible:
		spawnNosy()
		abilities.visible=false

func spawnNosy():
	var posArray:Array[Vector3]
	posArray.append(Vector3(-11.69,1.519,10.963))
	posArray.append(Vector3(-11.69,1.519,6.952))
	posArray.append(Vector3(-8.021,2.575,10.963))
	posArray.append(Vector3(-8.021,2.575,6.952))
	posArray.append(Vector3(-4.371,3.54,10.963))
	posArray.append(Vector3(-4.371,3.54,6.952))
	posArray.append(Vector3(6.147,2.575,10.963))
	posArray.append(Vector3(6.147,2.575,6.952))
	posArray.append(Vector3(9.821,3.54,10.963))
	posArray.append(Vector3(9.821,3.54,6.952))												#xd
	posArray.append(Vector3(13.471,4.657,10.963))
	posArray.append(Vector3(13.471,4.657,6.952))
	posArray.append(Vector3(-11.69,1.519,-6.661))
	posArray.append(Vector3(-11.69,1.519,-10.672))
	posArray.append(Vector3(-8.021,2.575,-6.661))
	posArray.append(Vector3(-8.021,2.575,-10.672))
	posArray.append(Vector3(-4.371,3.54,-6.661))
	posArray.append(Vector3(-4.371,3.54,-10.672))
	posArray.append(Vector3(6.147,2.575,-6.661))
	posArray.append(Vector3(6.147,2.575,-10.672))
	posArray.append(Vector3(9.821,3.54,-6.661))
	posArray.append(Vector3(9.821,3.54,-10.672))
	posArray.append(Vector3(13.471,4.657,-6.661))
	posArray.append(Vector3(13.471,4.657,-10.672))
	posArray.erase(student.global_position)
	var nosy=nosyStudent.instantiate()
	nosy.name="nosyStudent"
	nosy.position=posArray.pick_random()
	student.get_parent().add_child(nosy)
	student.get_parent().create_child.rpc(nosy.position)

func randomizeKey():
	var key=randi_range(0,3)
	if key==0:
		randomizedKey="A"
	elif key==1:
		randomizedKey="W"
	elif key==2:
		randomizedKey="S"
	elif key==3:
		randomizedKey="D"
	pressText.text="[font size=48][outline_size=4][outline_color=080808]PRESS[color=FF2222] "+randomizedKey

func syncButtons():
	pass
	#var posArray:Array[Vector3]
	#posArray.append(Vector3(-11.69,1.519,10.963))
	#posArray.append(Vector3(-11.69,1.519,6.952))
	#posArray.append(Vector3(-8.021,2.575,10.963))
	#posArray.append(Vector3(-8.021,2.575,6.952))
	#posArray.append(Vector3(-4.371,3.54,10.963))
	#posArray.append(Vector3(-4.371,3.54,6.952))
	#posArray.append(Vector3(6.147,2.575,10.963))
	#posArray.append(Vector3(6.147,2.575,6.952))
	#posArray.append(Vector3(9.821,3.54,10.963))
	#posArray.append(Vector3(9.821,3.54,6.952))														xd
	#posArray.append(Vector3(13.471,4.657,10.963))
	#posArray.append(Vector3(13.471,4.657,6.952))
	#posArray.append(Vector3(-11.69,1.519,-6.661))
	#posArray.append(Vector3(-11.69,1.519,-10.672))
	#posArray.append(Vector3(-8.021,2.575,-6.661))
	#posArray.append(Vector3(-8.021,2.575,-10.672))
	#posArray.append(Vector3(-4.371,3.54,-6.661))
	#posArray.append(Vector3(-4.371,3.54,-10.672))
	#posArray.append(Vector3(6.147,2.575,-6.661))
	#posArray.append(Vector3(6.147,2.575,-10.672))
	#posArray.append(Vector3(9.821,3.54,-6.661))
	#posArray.append(Vector3(9.821,3.54,-10.672))
	#posArray.append(Vector3(13.471,4.657,-6.661))
	#posArray.append(Vector3(13.471,4.657,-10.672))
	#for i in posArray:
		#for j in checks.get_children():
			#for k in j.get_overlapping_bodies():
				#if k.name=="studentPlayer":
					#print(k.name,k.global_position)
		#if createCheckOnce:
			#var sc=seatCheck.instantiate()
			#checks.add_child(sc)
			#sc.global_position=i
	#createCheckOnce=false
	#
	#var a=checks.get_children()
	#for i in a[0].get_overlapping_bodies():
		#print(i.name,i.global_position)
	

func addProgress():
	var progressCount=str(minigameLabel.text).replace("[font size=30][outline_size=4][outline_color=080808][color=66AA00]","")
	progressCount=str(int(progressCount)+1)
	minigameLabel.text="[font size=30][outline_size=4][outline_color=080808][color=66AA00]"+progressCount
	if progressCount>=str(minigameLabel2.text).replace("[font size=30][outline_size=4][outline_color=080808][color=66AA00]/",""):
		get_parent().get_parent().showMsg("Students Win")
	sync_minigame_label.rpc(minigameLabel.text)
	

func minigame():
	if Input.is_action_just_pressed("Activate"):
		minigameActive=not minigameActive
		if minigameMode:
			if minigameActive:
				tutorialText.text="[outline_size=4][outline_color=080808][font size=24]PRESS [color=11FF00]E[/color] TO CANCEL!\n[color=FF1100] WATCH OUT THE EXAMINATOR CAN SEE YOU CHEATING!!1![/color]"
				correctBar.visible=true
				randomizeKey()
				pressText.visible=true
				cardAnimation.play("showPhone")
				animationActive=true
				await cardAnimation.animation_finished  # Wait for animation if needed
				animationActive=false
				syncPos2()
			else:
				tutorialText.text="[outline_size=4][outline_color=080808][font size=24]PRESS [color=11FF00]E[/color] TO CHEAT ON THE TEST!!1!"
				correctBar.visible=false
				pressText.visible=false
				cardAnimation.play("hidePhone")
				animationActive=true
				await cardAnimation.animation_finished  # Wait for animation if needed
				animationActive=false
				syncPos2()
		else:
			if minigameActive:
				hitBarArea.position.x=randi_range(0,900)
				tutorialText.text="[outline_size=4][outline_color=080808][font size=24]PRESS [color=11FF00]E[/color] TO CANCEL!\n[color=FF1100] WATCH OUT THE EXAMINATOR CAN SEE YOU CHEATING!!1![/color]"
				cheatText.visible=true
				hitBar.visible=true
				cursor.visible=true
				correctBar.visible=true
				cardAnimation.play("showCard")
				animationActive=true
				await cardAnimation.animation_finished  # Wait for animation if needed
				animationActive=false
				syncPos()
			else:
				tutorialText.text="[outline_size=4][outline_color=080808][font size=24]PRESS [color=11FF00]E[/color] TO CHEAT ON THE TEST!!1!"
				cheatText.visible=false
				hitBar.visible=false
				cursor.visible=false
				correctBar.visible=false
				cardAnimation.play("hideCard")
				animationActive=true
				await cardAnimation.animation_finished  # Wait for animation if needed
				animationActive=false
				syncPos()
				
	minigameLogic()

func minigameLogic():
	if Input.is_action_just_pressed("Shoot") and minigameActive and penaltyTimer.is_stopped() and not minigameMode:
		hitBarArea.position.x=randi_range(0,900)
		if inArea:
			cheatingBar.value+=5.0
			if cheatingBar.value==100.0:
				minigameActive=false
				cheatingBar.value=0.0
				minigameMode=true
				tutorialText.text="[outline_size=4][outline_color=080808][font size=24]PRESS [color=11FF00]E[/color] TO CHEAT ON THE TEST!!1!"
				cheatText.visible=false
				hitBar.visible=false
				cursor.visible=false
				correctBar.visible=false
				cardAnimation.play("hideCard")
				animationActive=true
				await cardAnimation.animation_finished  # Wait for animation if needed
				animationActive=false
				addProgress()
				syncPos()
		else:
			cheatingBar.value-=15.0
			penaltyAnimation.play("penalty")
			penaltyTimer.wait_time=1.7
			penaltyTimer.start()
	if minigameActive and penaltyTimer.is_stopped() and minigameMode and(Input.is_action_just_pressed("Up") or Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right") or Input.is_action_just_pressed("Down")):
		if (Input.is_action_just_pressed("Up") and randomizedKey=="W") or (Input.is_action_just_pressed("Left") and randomizedKey=="A") or (Input.is_action_just_pressed("Right") and randomizedKey=="D") or (Input.is_action_just_pressed("Down") and randomizedKey=="S"):
			cheatingBar.value+=5.0
			if cheatingBar.value==100.0:
				minigameActive=false
				cheatingBar.value=0.0
				minigameMode=false
				tutorialText.text="[outline_size=4][outline_color=080808][font size=24]PRESS [color=11FF00]E[/color] TO CHEAT ON THE TEST!!1!"
				correctBar.visible=false
				pressText.visible=false
				cardAnimation.play("hidePhone")
				animationActive=true
				await cardAnimation.animation_finished  # Wait for animation if needed
				pressText.visible=false
				animationActive=false
				addProgress()
				syncPos2()
			else:
				penaltyAnimation.play("correct")
				penaltyTimer.wait_time=0.7
				penaltyTimer.start()
		else:
			cheatingBar.value-=15.0
			penaltyAnimation.play("penalty_2")
			penaltyTimer.wait_time=1.7
			penaltyTimer.start()
		randomizeKey()

func mouse(event):
	if event is InputEventMouseMotion and Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		mouseMotion+=-event.relative*0.00015*DPI
		mouseMotion.x=clampf(mouseMotion.x,-Engine.time_scale*3,Engine.time_scale*3)
		mouseMotion.y=clampf(mouseMotion.y,-Engine.time_scale*3,Engine.time_scale*3)

func cameraRotation() ->void : 
	rotation.y+=mouseMotion.x
	rotation_degrees.y=clampf(rotation_degrees.y,-270.0,-90.0)
	cameraPivot.rotate_x(mouseMotion.y)
	cameraPivot.rotation_degrees.x=clampf(cameraPivot.rotation_degrees.x,-90.0,90.0)
	mouseMotion=Vector2.ZERO


func _on_area_2d_area_entered(_area: Area2D) -> void:
	if !multiplayer.has_multiplayer_peer():
		return
	if !is_multiplayer_authority():
		return
	inArea=true


func _on_area_2d_area_exited(_area: Area2D) -> void:
	if !multiplayer.has_multiplayer_peer():
		return
	if !is_multiplayer_authority():
		return 
	inArea=false
