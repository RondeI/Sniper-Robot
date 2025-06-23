extends CharacterBody3D

@onready var gunAnimation=$AnimationPlayer
const SPEED = 5.13
const JUMP_VELOCITY = 4.76
const AIR_CONTROL = 0.08
const GROUND_FRICTION = 22.0
var mouseMotion =Vector2.ZERO
var DPI:int=6
@onready var cameraPivot=$Neck
@onready var shootPoint=$Neck/Camera3D/RayCast3D
@onready var camera=$Neck/Camera3D
@onready var sphere=$oko
@onready var sniperRifle=$Neck/SK_Sniper_Rifle_Full3
@onready var waitScreen=$ColorRect2
@onready var decals=get_parent().get_node("Decals")
@onready var cameraInfo=$RichTextLabel
@onready var electricInfo=$RichTextLabel3
const decalScene = preload("res://sponsor_wykladu.tscn")
@onready var chargeBar=$TextureProgressBar
var canShoot:bool=false
var cameraEntered:bool=false
var defaultNeckPosition:Vector3=Vector3(0.0,1.273,-0.47)
var canEnterCamera:bool=false
var canEnterElectric:bool=false
var electricEntered:bool=false
var cameraMarkerPosition:Vector3=defaultNeckPosition
var cameraButton
var gameOver:bool=false
var nosyEntered:bool=false
@onready var nosyTimer=$Neck/Area3D/NosyTimer
@onready var chargedAnimation=$FullyCharged
@onready var waitScreenTimer=$cameraTimer
@onready var clockLabel=$RichTextLabel2
@onready var clockTimer=$RichTextLabel2/Timer
@onready var electricBox=$ColorRect3
@onready var cableConnection1:bool=false
@onready var cableConnection2:bool=false
@onready var cableConnection3:bool=false
@onready var cableConnection4:bool=false
@onready var nosyText=$RichTextLabel4
@onready var timerAnim=$AnimationPlayer2
func removeExaminerPlayer():
	get_parent().showMsg("Students Win")
	queue_free()

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	if is_multiplayer_authority():
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	chargeBar.visible=false
	cameraInfo.visible=false
	electricInfo.visible=false
	camera.current=is_multiplayer_authority()


func _physics_process(delta: float) -> void:
	if !multiplayer.has_multiplayer_peer():
		return
	if !is_multiplayer_authority():
		return
	
	cameraRotation()
	
	if not cameraEntered and not electricEntered:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity()*1.33 * delta
		# Jump
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
	
	
		# Input movement
		var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if is_on_floor():
			if direction:
				# Snap to movement on input
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				# Apply friction to stop
				velocity.x = move_toward(velocity.x, 0.0, GROUND_FRICTION * delta)
				velocity.z = move_toward(velocity.z, 0.0, GROUND_FRICTION * delta)
		else:
			if direction:
				# Air control
				velocity.x = lerp(velocity.x, direction.x * SPEED, AIR_CONTROL)
				velocity.z = lerp(velocity.z, direction.z * SPEED, AIR_CONTROL)
	else:
		velocity.x = 0.
		velocity.z = 0.
	move_and_slide()

func _process(delta: float) -> void:
	if !multiplayer.has_multiplayer_peer():
		return
	if !is_multiplayer_authority():
		return
	updateTime()
	updateBar(delta)
	nosy()
	electricityCheck()

func electricityCheck():
	if not get_parent().isElectricityOn and cameraEntered:
		sniperRifle.visible=true
		sphere.visible=true
		cameraInfo.text="[font size=24][outline_size=4][outline_color=080808]PRESS[color=22FF00] E[/color] TO VIEW THE CAMERA :DBBDDBADAWDGYUOAWDAWD AWD DVYyuioOVYIDovyawdvhulawdcvtui"
		global_position=defaultNeckPosition
		cameraEntered=false
		cameraButton.openAnimation.play_backwards("activate")
		
func updateTime():
	if multiplayer.get_peers().size()==1 and clockTimer.is_stopped():
		clockTimer.start()
		clockLabel.visible=true
	if not clockTimer.is_stopped():
		if not get_parent().isElectricityOn:
			clockTimer.paused=true
		if not get_parent().endingMsg.visible:
			var minutes=int(clockTimer.time_left/60)
			var sec:float=fmod(clockTimer.time_left,60)
			var msg=str(minutes).pad_zeros(1)+":"+str(sec).pad_zeros(2).pad_decimals(3)
			clockLabel.text="[font size=30][outline_size=4][outline_color=080808]"+msg
		else:
			clockTimer.stop()
	elif get_parent().isElectricityOn and not get_parent().endingMsg.visible and multiplayer.get_peers().size()==1:
		clockTimer.paused=false
		

func _input(event):
	if !is_multiplayer_authority():
		return
	mouse(event)
	shooting()
	if Input.is_action_just_pressed("ESC"):
		get_parent().exit_game(name.to_int())
	cameraInput()
	electricityInput()

func updateBar(delta):
	if Input.is_action_pressed("Aim"):
		chargeBar.value+=delta
	elif chargeBar.value>0:
		chargeBar.value-=delta*0.5
		if chargeBar.value<0:
			chargeBar.value=0
	if chargeBar.value>=chargeBar.max_value:
		if canShoot==false:
			chargedAnimation.play("ready")
			canShoot=true
	else:
		chargeBar.modulate=Color(1,1,1,0.6)
		chargedAnimation.stop()
		canShoot=false
	if chargeBar.value>0 and not chargeBar.visible:
		chargeBar.visible=true
	if chargeBar.value==0 and chargeBar.visible:
		chargeBar.visible=false

func shooting():
	if Input.is_action_just_released("Shoot") and canShoot and not get_parent().endingMsg.visible:
		canShoot=false
		chargeBar.value=0
		gunAnimation.play("shoot")
		shootPoint.force_raycast_update()
		if shootPoint.is_colliding():
			var decal=decalScene.instantiate()
			decal.position=shootPoint.get_collision_point()
			decal.look_at_from_position(shootPoint.get_collision_point(),global_position,shootPoint.get_collision_normal())
			if shootPoint.get_collision_normal()!=Vector3.UP :
				decal.rotate_object_local(Vector3(1,0,0),90)
				decal.rotate_object_local(Vector3(0,0,1),180)
			if shootPoint.get_collision_normal()==Vector3.UP :
				decal.rotate_object_local(Vector3(0,1,0),PI)
			decals.add_child(decal,true)
			shootPoint.force_raycast_update()
			var collider=shootPoint.get_collider()
			if collider.name=="studentPlayer":
				gameOver=true
				collider.removeStudentPlayer()
			if collider.name=="studentNotPlayer" and not gameOver:
				removeExaminerPlayer()

func mouse(event):
	if event is InputEventMouseMotion and Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		mouseMotion+=-event.relative*0.00015*DPI
		mouseMotion.x=clampf(mouseMotion.x,-Engine.time_scale*3,Engine.time_scale*3)
		mouseMotion.y=clampf(mouseMotion.y,-Engine.time_scale*3,Engine.time_scale*3)

func electricityInput():
	if not get_parent().isElectricityOn:
		if Input.is_action_just_pressed("Activate") and (canEnterElectric or electricEntered):
			if electricEntered:
				Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
				electricEntered=false
				electricInfo.text="[font size=24][outline_size=4][outline_color=080808]PRESS[color=22FF00] E[/color] TO OPEN ELECTRIC BOX"
				electricBox.visible=false
			else:
				Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
				electricEntered=true
				electricInfo.text="[font size=24][outline_size=4][outline_color=080808]PRESS[color=22FF00] E[/color] TO EXIT"
				electricBox.visible=true

func cameraInput():
	if get_parent().isElectricityOn:
		if Input.is_action_just_pressed("Activate") and (canEnterCamera or cameraEntered) and waitScreenTimer.is_stopped():
			if cameraEntered:
				sniperRifle.visible=true
				sphere.visible=true
				cameraInfo.text="[font size=24][outline_size=4][outline_color=080808]PRESS[color=22FF00] E[/color] TO VIEW THE CAMERA :DBBDDBADAWDGYUOAWDAWD AWD DVYyuioOVYIDovyawdvhulawdcvtui"
				global_position=defaultNeckPosition
				cameraEntered=false
				cameraButton.openAnimation.play_backwards("activate")
			else:
				velocity=Vector3.ZERO
				cameraButton.openAnimation.play("activate")
				defaultNeckPosition=global_position
				global_position=cameraMarkerPosition
				sniperRifle.visible=false
				sphere.visible=false
				cameraEntered=true
				if is_multiplayer_authority():
					waitScreen.visible=true
					waitScreenTimer.start()
					cameraInfo.text="[font size=24][outline_size=4][outline_color=080808]PRESS[color=22FF00] E[/color] TO EXIT"
					cameraInfo.visible=true
	elif not cameraInfo.text=="[font size=24][outline_size=4][outline_color=FF0808]GO TO ELECTRIC BOX TO FIX ELECTRICITY!":
		cameraInfo.text="[font size=24][outline_size=4][outline_color=FF0808]GO TO ELECTRIC BOX TO FIX ELECTRICITY!"
		

func cameraRotation() ->void : 
	if not electricEntered:
		rotate_y(mouseMotion.x)
		cameraPivot.rotate_x(mouseMotion.y)
		cameraPivot.rotation_degrees.x=clampf(cameraPivot.rotation_degrees.x,-90.0,90.0)
	mouseMotion=Vector2.ZERO


func _on_area_3d_area_entered(area: Area3D) -> void:
	canEnterCamera=true
	cameraMarkerPosition=area.cameraPos.global_position
	cameraButton=area
	if is_multiplayer_authority():
		cameraInfo.visible=true


func _on_area_3d_area_exited(_area: Area3D) -> void:
	canEnterCamera=false
	if not cameraEntered:
		cameraInfo.visible=false
	cameraMarkerPosition=defaultNeckPosition


func _on_camera_timer_timeout() -> void:
	waitScreen.visible=false


func _on_timer_timeout() -> void:
	get_parent().showMsg("Examinator Wins")


func _on_area_3d_2_area_entered(_area: Area3D) -> void:
	canEnterElectric=true
	if is_multiplayer_authority():
		if not electricInfo.text=="[font size=24][outline_size=4][outline_color=080808]PRESS[color=22FF00] E[/color] TO OPEN ELECTRIC BOX" and not get_parent().isElectricityOn:
			electricInfo.text="[font size=24][outline_size=4][outline_color=080808]PRESS[color=22FF00] E[/color] TO OPEN ELECTRIC BOX"
		elif not electricInfo.text=="[font size=24][outline_size=4][outline_color=080808][color=22FF00]ELECTRICITY IS ON!!! :D[/color]" and get_parent().isElectricityOn:
			electricInfo.text="[font size=24][outline_size=4][outline_color=080808][color=22FF00]ELECTRICITY IS ON!!! :D[/color]"
		electricInfo.visible=true


func _on_area_3d_2_area_exited(_area: Area3D) -> void:
	canEnterElectric=false
	if not electricEntered:
		electricInfo.visible=false


func resetButtons():
	$ColorRect3/Button.button_pressed=false
	$ColorRect3/Button2.button_pressed=false
	$ColorRect3/Button3.button_pressed=false
	$ColorRect3/Button4.button_pressed=false
	$ColorRect3/Button5.button_pressed=false
	$ColorRect3/Button6.button_pressed=false
	$ColorRect3/Button7.button_pressed=false
	$ColorRect3/Button8.button_pressed=false
	$ColorRect3/TextureRect.texture=preload("res://Sprites/fuse.png")
	$ColorRect3/TextureRect2.texture=preload("res://Sprites/fuse.png")
	$ColorRect3/TextureRect3.texture=preload("res://Sprites/fuse.png")
	$ColorRect3/TextureRect4.texture=preload("res://Sprites/fuse.png")
	$ColorRect3/TextureRect5.texture=preload("res://Sprites/fuse.png")
	$ColorRect3/TextureRect6.texture=preload("res://Sprites/fuse.png")
	$ColorRect3/TextureRect7.texture=preload("res://Sprites/fuse.png")
	$ColorRect3/TextureRect8.texture=preload("res://Sprites/fuse.png")


func cableCheck():
	if $ColorRect3/Button.button_pressed and $ColorRect3/Button7.button_pressed and cableConnection1==false:
		cableConnection1=true
	elif $ColorRect3/Button2.button_pressed and $ColorRect3/Button5.button_pressed and cableConnection2==false:
		cableConnection2=true
	elif $ColorRect3/Button3.button_pressed and $ColorRect3/Button8.button_pressed and cableConnection3==false:
		cableConnection3=true
	elif $ColorRect3/Button4.button_pressed and $ColorRect3/Button6.button_pressed and cableConnection4==false:
		cableConnection4=true
	resetButtons()
	$ColorRect3.draw(cableConnection1,cableConnection2,cableConnection3,cableConnection4)
	if cableConnection1 and cableConnection2 and cableConnection3 and cableConnection4:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
		electricEntered=false
		electricBox.visible=false
		get_parent().setElectricity(true)
		electricInfo.text="[font size=24][outline_size=4][outline_color=080808][color=22FF00]ELECTRICITY IS ON!!! :D[/color]"
		clockTimer.paused=false

func shouldCheckCable():
	if ($ColorRect3/Button.button_pressed or $ColorRect3/Button2.button_pressed or $ColorRect3/Button3.button_pressed or $ColorRect3/Button4.button_pressed) and ($ColorRect3/Button5.button_pressed or $ColorRect3/Button6.button_pressed or $ColorRect3/Button7.button_pressed or $ColorRect3/Button8.button_pressed):
		cableCheck()

func _on_button_toggled(toggled_on: bool) -> void:
	if not cableConnection1:
		if toggled_on:
			$ColorRect3/TextureRect.texture=preload("res://Sprites/fuseLit.png")
			$ColorRect3/Button2.button_pressed=false
			$ColorRect3/Button3.button_pressed=false
			$ColorRect3/Button4.button_pressed=false
			$ColorRect3/TextureRect2.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect3.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect4.texture=preload("res://Sprites/fuse.png")
			shouldCheckCable()
		else:
			$ColorRect3/TextureRect.texture=preload("res://Sprites/fuse.png")
	else:
		resetButtons()


func _on_button_2_toggled(toggled_on: bool) -> void:
	if not cableConnection2:
		if toggled_on:
			$ColorRect3/TextureRect2.texture=preload("res://Sprites/fuseLit.png")
			$ColorRect3/Button.button_pressed=false
			$ColorRect3/Button3.button_pressed=false
			$ColorRect3/Button4.button_pressed=false
			$ColorRect3/TextureRect.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect3.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect4.texture=preload("res://Sprites/fuse.png")
			shouldCheckCable()
		else:
			$ColorRect3/TextureRect2.texture=preload("res://Sprites/fuse.png")
	else:
		resetButtons()


func _on_button_3_toggled(toggled_on: bool) -> void:
	if not cableConnection3:
		if toggled_on:
			$ColorRect3/TextureRect3.texture=preload("res://Sprites/fuseLit.png")
			$ColorRect3/Button2.button_pressed=false
			$ColorRect3/Button.button_pressed=false
			$ColorRect3/Button4.button_pressed=false
			$ColorRect3/TextureRect2.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect4.texture=preload("res://Sprites/fuse.png")
			shouldCheckCable()
		else:
			$ColorRect3/TextureRect3.texture=preload("res://Sprites/fuse.png")
	else:
		resetButtons()


func _on_button_4_toggled(toggled_on: bool) -> void:
	if not cableConnection4:
		if toggled_on:
			$ColorRect3/TextureRect4.texture=preload("res://Sprites/fuseLit.png")
			$ColorRect3/Button2.button_pressed=false
			$ColorRect3/Button3.button_pressed=false
			$ColorRect3/Button.button_pressed=false
			$ColorRect3/TextureRect2.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect3.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect.texture=preload("res://Sprites/fuse.png")
			shouldCheckCable()
		else:
			$ColorRect3/TextureRect4.texture=preload("res://Sprites/fuse.png")
	else:
		resetButtons()


func _on_button_5_toggled(toggled_on: bool) -> void:
	if not cableConnection2:
		if toggled_on:
			$ColorRect3/TextureRect5.texture=preload("res://Sprites/fuseLit.png")
			$ColorRect3/Button6.button_pressed=false
			$ColorRect3/Button7.button_pressed=false
			$ColorRect3/Button8.button_pressed=false
			$ColorRect3/TextureRect6.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect7.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect8.texture=preload("res://Sprites/fuse.png")
			shouldCheckCable()
		else:
			$ColorRect3/TextureRect5.texture=preload("res://Sprites/fuse.png")
	else:
		resetButtons()


func _on_button_6_toggled(toggled_on: bool) -> void:
	if not cableConnection4:
		if toggled_on:
			$ColorRect3/TextureRect6.texture=preload("res://Sprites/fuseLit.png")
			$ColorRect3/Button5.button_pressed=false
			$ColorRect3/Button7.button_pressed=false
			$ColorRect3/Button8.button_pressed=false
			$ColorRect3/TextureRect5.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect7.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect8.texture=preload("res://Sprites/fuse.png")
			shouldCheckCable()
		else:
			$ColorRect3/TextureRect6.texture=preload("res://Sprites/fuse.png")
	else:
		resetButtons()


func _on_button_7_toggled(toggled_on: bool) -> void:
	if not cableConnection1:
		if toggled_on:
			$ColorRect3/TextureRect7.texture=preload("res://Sprites/fuseLit.png")
			$ColorRect3/Button6.button_pressed=false
			$ColorRect3/Button5.button_pressed=false
			$ColorRect3/Button8.button_pressed=false
			$ColorRect3/TextureRect6.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect5.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect8.texture=preload("res://Sprites/fuse.png")
			shouldCheckCable()
		else:
			$ColorRect3/TextureRect7.texture=preload("res://Sprites/fuse.png")
	else:
		resetButtons()


func _on_button_8_toggled(toggled_on: bool) -> void:
	if not cableConnection3:
		if toggled_on:
			$ColorRect3/TextureRect8.texture=preload("res://Sprites/fuseLit.png")
			$ColorRect3/Button6.button_pressed=false
			$ColorRect3/Button7.button_pressed=false
			$ColorRect3/Button5.button_pressed=false
			$ColorRect3/TextureRect6.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect7.texture=preload("res://Sprites/fuse.png")
			$ColorRect3/TextureRect5.texture=preload("res://Sprites/fuse.png")
			shouldCheckCable()
		else:
			$ColorRect3/TextureRect8.texture=preload("res://Sprites/fuse.png")
	else:
		resetButtons()

func nosy():
	if nosyEntered and nosyTimer.is_stopped() and cameraEntered:
		nosyTimer.start()
		nosyText.visible=true
	elif (not nosyEntered and not nosyTimer.is_stopped()) or (not cameraEntered and not nosyTimer.is_stopped()):
		nosyTimer.stop()
		nosyText.visible=false



func _on_area_nosy_area_entered(_area: Area3D) -> void:
	nosyEntered=true

func _on_area_nosy_area_exited(_area: Area3D) -> void:
	nosyEntered=false

func _on_nosy_timer_timeout() -> void:
	timerAnim.play("addTime")
	await timerAnim.animation_finished
	clockTimer.start(clockTimer.time_left+60.0)
	
