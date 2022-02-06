extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ModeChanger_pressed():
	get_parent().get_child(1).reset_score()
	get_parent().get_child(1).visible=false
	get_parent().get_child(3).visible=false
	get_parent().get_child(4).visible=false
	get_parent().get_child(5).visible=false
	get_parent().get_child(6).visible=false
	get_parent().get_child(0).visible=true
	Globals.mode=""
	get_parent().get_child(1).GameRestart()
	Globals.difficulty=""
	get_parent().get_child(0).get_child(1).visible=true
	get_parent().get_child(0).get_child(2).visible=true
	get_parent().get_child(0).get_child(3).visible=false
	get_parent().get_child(0).get_child(4).visible=false
	get_parent().get_child(0).get_child(6).visible=true
	pass # Replace with function body.
