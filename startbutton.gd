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
	if(self.name=="PvP"):
		Globals.mode="Multi"
		self.owner.visible=false
		self.owner.get_parent().get_child(1).visible=true
		self.owner.get_parent().get_child(3).visible=true
		self.owner.get_parent().get_child(4).visible=true
		self.owner.get_parent().get_child(5).visible=true
		self.owner.get_parent().get_child(6).visible=true
		self.owner.get_child(6).visible=false
	else:
		Globals.mode="Single"
		self.owner.get_child(1).visible=false
		self.owner.get_child(2).visible=false
		self.owner.get_child(3).visible=true
		self.owner.get_child(4).visible=true
		self.owner.get_child(5).visible=true
		self.owner.get_child(6).visible=false
	pass # Replace with function body.
