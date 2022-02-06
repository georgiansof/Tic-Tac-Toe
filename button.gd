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

func _on_Button_pressed():
	if Globals.paused==false:
		if self.text!='X' && self.text!='0':
			self.text = "X" if Globals.player==true else "0"
			Globals.moves_number += 1
			if(get_parent().verify_terminal_state()==true):
				get_parent().GameOver(Globals.Winner)
			else:
				Globals.player = !Globals.player
				if Globals.mode=="Single" && Globals.player == true :
					get_parent().Bot_Move()
	pass # Replace with function body.
