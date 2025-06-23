extends Node3D

@rpc("call_local","any_peer") 
func delete() -> void:
	queue_free()

func _on_area_3d_area_entered(_area: Area3D) -> void:
	delete.rpc()
