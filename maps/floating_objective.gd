extends Area3D


func _on_body_entered(body: Node3D) -> void:
	print("PLAYER ENTERED THE FLOATING OBJECTIVE HITBOX")

func _physics_process(delta: float) -> void:
	global_rotation.x += 1
