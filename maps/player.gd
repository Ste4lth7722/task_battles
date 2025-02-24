extends CharacterBody3D

@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5

@export var p1_material: StandardMaterial3D
@export var p2_material: StandardMaterial3D

@export var camera: Camera3D

@onready var game = $"../.." # This should always be the game node, as long as the player is placed directly in a level, that is directly in the game node.

var p2_controlling: bool = false
var can_control: bool = false

var unique_id: int


func _ready() -> void:
	unique_id = multiplayer.get_unique_id()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("movement_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir
	if not p2_controlling and GameManager.players[unique_id].player_num == "player_1": 
		can_control = true
	elif p2_controlling and GameManager.players[unique_id].player_num == "player_2":
		can_control = true
	else:
		can_control = false
	
	if can_control:
		input_dir = Input.get_vector("movement_left", "movement_right", "movement_forward", "movement_backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction = direction.rotated(Vector3.UP, camera.global_rotation.y) # Rotates movement based on camera's current y rotation, globally. This makes us move in the direction we are facing.
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_mouse_mode"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("switch_control"):
		switch_player_control()


func switch_player_control() -> void:
	p2_controlling = !p2_controlling # Toggle player 2's control. Initial = off
	
	if not p2_controlling: # If player 1 is controlling the character
		$MeshInstance3D.mesh.material = p1_material
		$MultiplayerSynchronizer.set_multiplayer_authority(GameManager.p1_unique_id)
	elif p2_controlling:
		$MeshInstance3D.mesh.material = p2_material
		$MultiplayerSynchronizer.set_multiplayer_authority(GameManager.p2_unique_id)
	game.update_controller_label(p2_controlling)
