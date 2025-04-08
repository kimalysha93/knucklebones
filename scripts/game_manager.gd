extends Node

var rng = RandomNumberGenerator.new()
var dice_roll = 0

# current turn: 0 = opponent (false), 1 = player (true)
# only used at start of game
var turn = 1

# keeps track of if player is allowed to select a column (during their turn)
var player_input = false

# numbers in grid align with dice value on screen (no axis flip)
var player_grid = [
	[0,0,0],
	[0,0,0],
	[0,0,0],]

# may axis flip (when displaying), bc dice go upwards instead of downward
# can still code it normally then flip it at the end
var opp_grid = [
	[0,0,0],
	[0,0,0],
	[0,0,0],]

@onready var game_manager: Node = $"."
@onready var player_dice_roll: Label = $DiceLabels/PlayerDiceRoll
@onready var opp_dice_roll: Label = $DiceLabels/OppDiceRoll
@onready var roll_timer: Timer = $"../RollTimer"

# Player Dice Grid
@onready var player_dice_roll_00: Label = $DiceLabels/PlayerGrid/PlayerDiceRoll_00
@onready var player_dice_roll_10: Label = $DiceLabels/PlayerGrid/PlayerDiceRoll_10
@onready var player_dice_roll_20: Label = $DiceLabels/PlayerGrid/PlayerDiceRoll_20
@onready var player_dice_roll_01: Label = $DiceLabels/PlayerGrid/PlayerDiceRoll_01
@onready var player_dice_roll_11: Label = $DiceLabels/PlayerGrid/PlayerDiceRoll_11
@onready var player_dice_roll_21: Label = $DiceLabels/PlayerGrid/PlayerDiceRoll_21
@onready var player_dice_roll_02: Label = $DiceLabels/PlayerGrid/PlayerDiceRoll_02
@onready var player_dice_roll_12: Label = $DiceLabels/PlayerGrid/PlayerDiceRoll_12
@onready var player_dice_roll_22: Label = $DiceLabels/PlayerGrid/PlayerDiceRoll_22

# Opponent Dice Grid
@onready var opp_dice_roll_00: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_00
@onready var opp_dice_roll_10: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_10
@onready var opp_dice_roll_20: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_20
@onready var opp_dice_roll_01: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_01
@onready var opp_dice_roll_11: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_11
@onready var opp_dice_roll_21: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_21
@onready var opp_dice_roll_02: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_02
@onready var opp_dice_roll_12: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_12
@onready var opp_dice_roll_22: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_22

# Player Score Labels
@onready var player_score_total: Label = $ScoreLabels/PlayerScoreTotal
@onready var player_score_0: Label = $ScoreLabels/PlayerScore0
@onready var player_score_1: Label = $ScoreLabels/PlayerScore1
@onready var player_score_2: Label = $ScoreLabels/PlayerScore2

# Opponent Score Labels
@onready var opponent_score_total: Label = $ScoreLabels/OpponentScoreTotal
@onready var opp_score_0: Label = $ScoreLabels/OppScore0
@onready var opp_score_1: Label = $ScoreLabels/OppScore1
@onready var opp_score_2: Label = $ScoreLabels/OppScore2


# scores
var die_values = [
	[0],
	[0,1,4,9],
	[0,2,8,18],
	[0,3,12,27],
	[0,4,16,36],
	[0,5,20,45],
	[0,6,24,54],
]



func _ready() -> void:
	if turn:
		player_turn()
	else:
		opp_turn()

# update player grid
func update_player_board():
	player_dice_roll_00.text = str(player_grid[0][0])
	player_dice_roll_10.text = str(player_grid[1][0])
	player_dice_roll_20.text = str(player_grid[2][0])
	player_dice_roll_01.text = str(player_grid[0][1])
	player_dice_roll_11.text = str(player_grid[1][1])
	player_dice_roll_21.text = str(player_grid[2][1])
	player_dice_roll_02.text = str(player_grid[0][2])
	player_dice_roll_12.text = str(player_grid[1][2])
	player_dice_roll_22.text = str(player_grid[2][2])

# update opponent grid
func update_opp_board():
	opp_dice_roll_00.text = str(opp_grid[0][0])
	opp_dice_roll_10.text = str(opp_grid[1][0])
	opp_dice_roll_20.text = str(opp_grid[2][0])
	opp_dice_roll_01.text = str(opp_grid[0][1])
	opp_dice_roll_11.text = str(opp_grid[1][1])
	opp_dice_roll_21.text = str(opp_grid[2][1])
	opp_dice_roll_02.text = str(opp_grid[0][2])
	opp_dice_roll_12.text = str(opp_grid[1][2])
	opp_dice_roll_22.text = str(opp_grid[2][2])

# updates user-facing boards and calculates scores
func update_all():
	update_player_board()
	update_opp_board()
	# calculate and update column scores and total scores
		# use dictionary
	
	# player column
	# 0
	var player_score_col_0 = count_die(player_grid, 0)
	# 1
	var player_score_col_1 = count_die(player_grid, 1)
	# 2
	var player_score_col_2 = count_die(player_grid, 2)
	# total score (peak variable name right here...)
	var player_total_score = player_score_col_0 + player_score_col_1 + player_score_col_2
	
	# update player score labels
	player_score_0.text = str(player_score_col_0)
	player_score_1.text = str(player_score_col_1)
	player_score_2.text = str(player_score_col_2)
	player_score_total.text = str(player_total_score)
	
	# opponent column
	# 0
	var opp_score_col_0 = count_die(opp_grid, 0)
	# 1
	var opp_score_col_1 = count_die(opp_grid, 1)
	# 2
	var opp_score_col_2 = count_die(opp_grid, 2)
	# total score (peak variable name right here...)
	var opp_total_score = opp_score_col_0 + opp_score_col_1 + opp_score_col_2
	
	# update player score labels
	opp_score_0.text = str(opp_score_col_0)
	opp_score_1.text = str(opp_score_col_1)
	opp_score_2.text = str(opp_score_col_2)
	opponent_score_total.text = str(opp_total_score)

func count_die(grid, col):
	var player_die_count = {
		"0":0, "1":0, "2":0, "3":0, "4":0, "5":0, "6":0
	}
	
	var col_total = 0
	
	for i in range(3):
		if grid[i][col] != 0:
			player_die_count[str(grid[i][col])] += 1
	
	for key in player_die_count.keys():
		col_total += die_values[int(key)][player_die_count[key]]
	
	return col_total


# rolls the dice for player
func player_roll():
	dice_roll = int(floor(rng.randf_range(1,7)))
	# instead of changing text, would change sprite here
	player_dice_roll.text = str(dice_roll)
	# return dice_roll
	
# rolls the dice for opponent
func opp_roll():
	dice_roll = int(floor(rng.randf_range(1,7)))
	# instead of changing text, would change sprite here
	opp_dice_roll.text = str(dice_roll)
	# return dice_roll


func player_turn():
	# start dice rolling animation here
	await get_tree().create_timer(2).timeout
	player_roll()
	player_input = true # set to true when player can go
	
	# wait for player input to select column
	# _on_player_column_0_input_event function



func _on_player_column_0_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if player_input && event.is_pressed():
		var available = false
		# check if spot in column, add dice if available
		for i in range(3):
			if player_grid[i][0] == 0:
				available = true
				player_grid[i][0] = dice_roll
				# visual update to player grid
				break

		# statement only triggers if dice was added to the column
		if available:
			# function for eliminating dice on opponent side
			update_all()
			# if board is not full, continue playing
				# set player_input to false so player can't click anymore
			player_input = false
			opp_turn()
			# otherwise, end game and declare winner


func _on_player_column_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if player_input && event.is_pressed():
		var available = false
		# check if spot in column, add dice if available
		for i in range(3):
			if player_grid[i][1] == 0:
				available = true
				player_grid[i][1] = dice_roll
				# visual update to player grid
				break

		# statement only triggers if dice was added to the column
		if available:
			# function for eliminating dice on opponent side
			update_all()
			# if board is not full, continue playing
				# set player_input to false so player can't click anymore
			player_input = false
			opp_turn()
			# otherwise, end game and declare winner


func _on_player_column_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if player_input && event.is_pressed():
		var available = false
		# check if spot in column, add dice if available
		for i in range(3):
			if player_grid[i][2] == 0:
				available = true
				player_grid[i][2] = dice_roll
				# visual update to player grid
				break

		# statement only triggers if dice was added to the column
		if available:
			# function for eliminating dice on opponent side
			update_all()
			# if board is not full, continue playing
				# set player_input to false so player can't click anymore
			player_input = false
			opp_turn()
			# otherwise, end game and declare winner


func opp_turn():
	# start dice rolling animation here
	await get_tree().create_timer(2).timeout
	opp_roll()
	
	var broke = false
	
	# randomly decide opp column for now (use timer)
	for i in range(3):
		for j in range(3):
			if opp_grid[i][j] == 0:
				opp_grid[i][j] = dice_roll
				broke = true
				break
		if broke:
			break

	# function for eliminating dice on opponent side
	
	# calculate and update column score and total score
	update_all()
	
	# if board is not full, continue playing
	player_turn()
	# otehrwise, end game and declare winner

# update player grid
