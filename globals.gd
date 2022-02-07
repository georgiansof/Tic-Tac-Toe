extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player := false
var Winner := "None"
var X_score := 0
var O_score := 0
var mode := ""
var paused := false
var difficulty = ""
var terminal_states = []
var moves_number := 0
var file = File.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in range(19685):
			terminal_states.append(0)
	var content
	if(file.file_exists("res://save_game.dat")):
		file.open("res://save_game.dat", File.READ)
		content=file.get_as_text()
		if(content==""):
			resetAI_DB()
			content=file.get_as_text()
		file.close()
		content=content.split(" ")
		for i in range(19685):
			terminal_states[i]=int(float(content[i]))
	else:
		resetAI_DB()
	pass # Replace with function body.
	
func save():
	var savegame:=""
	for i in range(19685):
		savegame+=(str(terminal_states[i])+" ")
	file.open("res://save_game.dat", File.WRITE)
	file.store_string(savegame)
	file.close()
	pass

func resetAI_DB():
	var file2 = File.new()
	var empty:=""
	for i in range(19685):
		empty+="0 "
		terminal_states[i]=0
	file2.open("res://save_game.dat", File.WRITE)
	file2.store_string(empty)
	file2.close()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
