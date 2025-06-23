extends StaticBody3D

@onready var student=$".."

@rpc("call_local") 
func delete() -> void:
	student.queue_free()


func removeStudentPlayer() -> void:
	student.get_parent().showMsg("Examinator Wins")
	delete.rpc()
