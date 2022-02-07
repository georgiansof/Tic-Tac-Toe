extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var button_grid = [[null,null,null],
				[null,null,null],
				[null,null,null],]

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for i in range(9):
# warning-ignore:integer_division
		button_grid[i/3][i%3]=children[i+1]
	pass # Replace with function body.

func verify_diag_p() -> bool:
	if(button_grid[0][0].text==""):
		return false
	var type=button_grid[0][0].text
	for i in range(1,3):
		if(button_grid[i][i].text=="" || button_grid[i][i].text!=type):
			return false
	Globals.Winner=button_grid[0][0].text
	return true
	
func verify_diag_s() -> bool:
	if(button_grid[0][2].text==""):
		return false
	var type=button_grid[0][2].text
	for i in range(1,3):
		if(button_grid[i][2-i].text=="" || button_grid[i][2-i].text!=type):
			return false
	Globals.Winner=button_grid[0][2].text
	return true
	

func verify_col(x) -> bool:
	if(button_grid[0][x].text==""):
		return false
	var type=button_grid[0][x].text
	for i in range(1,3):
		if(button_grid[i][x].text=="" || button_grid[i][x].text!=type):
			return false
	Globals.Winner=button_grid[0][x].text
	return true

func verify_line(y) -> bool:
	if(button_grid[y][0].text==""):
		 return false
	var type=button_grid[y][0].text
	for j in range(1,3):
		if(button_grid[y][j].text=="" || button_grid[y][j].text!=type):
			return false
	Globals.Winner=button_grid[y][0].text
	return true

func verify_full() -> bool:
	for i in range(3):
		for j in range(3):
			if(button_grid[i][j].text==""):
				return false
	return true

func verify_terminal_state() -> bool:
	return verify_line(0) || verify_line(1) || verify_line(2) \
	|| verify_col(0) || verify_col(1) || verify_col(2)\
	|| verify_diag_p() || verify_diag_s() \
	|| verify_full()
	pass

func Reversed(state):
	for x in range(state.length()):
		if state[x]=='X': state[x]='O'
		elif state[x]=='O': state[x]='X'
	return state

func GameOver(winner):
	Globals.paused = true
	var UI = self.owner.get_child(2)
	UI.get_child(0).get_child(0).text = winner + " wins !"
	var current_state = Current_state()
	var rev_current_state = Reversed (current_state)
	if winner=="0":
		Globals.O_score += 1
		Globals.terminal_states[State_Index(current_state)]-=1
		Globals.terminal_states[State_Index(rev_current_state)]+=1
	elif winner=="X":
		Globals.X_score += 1
		Globals.terminal_states[State_Index(current_state)]+=1
		Globals.terminal_states[State_Index(rev_current_state)]-=1
	self.get_parent().get_child(3).text = "0's score is " + str(Globals.O_score)
	self.get_parent().get_child(4).text = "X's score is " + str(Globals.X_score)
	UI.visible = true
	Globals.save()
	pass
	
func GameRestart():
	Globals.moves_number = 0
	Globals.paused=false
	Globals.player=false
	Globals.Winner="None"
	for i in range(3):
		for j in range(3):
			button_grid[i][j].text=""
	get_parent().get_child(2).visible=false
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var player = rng.randi()
	if player%2==1:
		Globals.player=true
		Bot_Move()
	pass


func Current_state():
	var ret=""
	for i in range(3):
		for j in range(3):
			if button_grid[i][j].text=="": ret+="N"
			elif button_grid[i][j].text=="X": ret+="X"
			else: ret+="O"
	return ret
	pass

func terminal_string(state) -> bool:
	#lines
	if state[0]!='N' && state[0]==state[1] && state[1]==state[2] \
	   || state[3]!='N' && state[3]==state[4] && state[4]==state[5] \
	   || state[6]!='N' && state[6]==state[7] && state[7]==state[8]:
		return true
	#cols
	if state[0]!='N' && state[0]==state[3] && state[3]==state[6] \
	   || state[1]!='N' && state[1]==state[4] && state[4]==state[7] \
	   || state[2]!='N' && state[2]==state[5] && state[5]==state[8]:
		return true
	#diag_p
	if state[0]!='N' && state[0]==state[4] && state[4]==state[8]:
		return true
	#diag_s
	if state[2]!='N' && state[2]==state[4] && state[4]==state[6]:
		return true
	return false

func State_Index(state):
	var ind = 0
	var p:=1
	for i in range(state.length()):
		if state[i]=="O":
			ind+=0*p
			p*=2
		elif state[i]=="X":
			ind+=1*p
			p*=2
	return ind

func Score(state):
	if terminal_string(state):
		var ind=State_Index(state)
		return Globals.terminal_states[ind]
		
	var vmin=-2e9
	for i in range (state.length()):
		if state[i]=="N": 
			state[i]="O"
			var score1 = Score(state)
			vmin=min(vmin,score1)
			state[i]="X"
			var score2 = Score(state)
			vmin=min(vmin,score2)
			state[i]="N"
	return vmin

func CalcMove(state):
	var vmax=-2e9
	var vmaxstate=[]
	for i in range (state.length()):
		if state[i]=="N": 
			state[i]="O"
			var score1 = Score(state)
			if(score1>vmax):
				vmax=score1
				vmaxstate.clear()
				vmaxstate.append(state)
			elif score1==vmax:
				vmaxstate.append(state)
			state[i]="X"
			if terminal_string(state):
				return state
			var score2 = Score(state)
			if(score2>vmax):
				vmax=score2
				vmaxstate.clear()
				vmaxstate.append(state)
			elif score2==vmax:
				vmaxstate.append(state)
			state[i]="N"
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var ind = rng.randi_range(0,vmaxstate.size()-1)
	return vmaxstate[ind]


func CalcInd(state,nextstate) -> int:
	for i in range(state.length()):
		if(state[i]!=nextstate[i]):
			return i
	return 0


func Bot_Move(): # FIXME
	var empty_buttons = []
	for i in range(3):
		for j in range(3):
			if button_grid[i][j].text=="":
				empty_buttons.append(button_grid[i][j])
	if empty_buttons.size()>0:
		if Globals.difficulty=="Random":
			var ind = int(rand_range(0,empty_buttons.size()-1))
			empty_buttons[ind]._on_Button_pressed()
		elif Globals.difficulty=="ML":
			if Globals.moves_number>=2:
				var state = Current_state()
				var nextstate = CalcMove(state)
				if(nextstate!=""):
					var ind = CalcInd(state,nextstate)
					button_grid[ind/3][ind%3]._on_Button_pressed()
				else:
					var ind = int(rand_range(0,empty_buttons.size()-1))
					empty_buttons[ind]._on_Button_pressed()
			else:
				if Globals.moves_number==0 || button_grid[1][1].text!="":
					var rng = RandomNumberGenerator.new()
					var ind
					var jnd
					rng.randomize()
					ind = rng.randi_range(0,1)
					rng.randomize()
					jnd = rng.randi_range(0,1)
					if ind==1:
						ind=2
					if jnd==1:
						jnd=2
					while button_grid[ind][jnd].text!="":
						rng.randomize()
						ind = rng.randi_range(0,1)
						rng.randomize()
						jnd = rng.randi_range(0,1)
						if ind==1:
							ind=2
						if jnd==1:
							jnd=2
					button_grid[ind][jnd]._on_Button_pressed()
				else:
					button_grid[1][1]._on_Button_pressed()
	pass

func reset_score():
	Globals.X_score = 0
	Globals.O_score = 0
	self.get_parent().get_child(3).text = "0's score is " + str(Globals.O_score)
	self.get_parent().get_child(4).text = "X's score is " + str(Globals.X_score)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
