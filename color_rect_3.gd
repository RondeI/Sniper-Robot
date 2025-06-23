extends ColorRect
var connected1:bool=false
var connected2:bool=false
var connected3:bool=false
var connected4:bool=false
func draw(a:bool,b:bool,c:bool,d:bool):
	connected1=a
	connected2=b
	connected3=c
	connected4=d
	queue_redraw()

func _draw() -> void:
	if connected1:
		draw_line(Vector2(62+32,61+32),Vector2(406.0,283.0),Color(0,255,0,255),3)
	if connected2:
		draw_line(Vector2(62+32,132.0+32),Vector2(406.0,61.0),Color(255,0,0,255),3)
	if connected3:
		draw_line(Vector2(62+32,283.0+32),Vector2(406.0,354.0),Color(255,0,255,255),3)
	if connected4:
		draw_line(Vector2(62+32,354.0+32),Vector2(406.0,132.0),Color(0,0,255,255),3)
		
