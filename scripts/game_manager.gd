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
	
var player_total_score = 0

# may axis flip (when displaying), bc dice go upwards instead of downward
# can still code it normally then flip it at the end
var opp_grid = [
	[0,0,0],
	[0,0,0],
	[0,0,0],]

var opp_total_score = 0

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
@onready var opp_dice_roll_00: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_20
@onready var opp_dice_roll_10: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_10
@onready var opp_dice_roll_20: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_00
@onready var opp_dice_roll_01: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_21
@onready var opp_dice_roll_11: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_11
@onready var opp_dice_roll_21: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_01
@onready var opp_dice_roll_02: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_22
@onready var opp_dice_roll_12: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_12
@onready var opp_dice_roll_22: Label = $DiceLabels/OppDiceRoll/OppGrid/OppDiceRoll_02

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

# rolls the dice for player
func player_roll():
	dice_roll = int(floor(rng.randf_range(1,7)))
	# dice_roll = int(floor(rng.randf_range(1,3)))
	# instead of changing text, would change sprite here
	player_dice_roll.text = str(dice_roll)
	# return dice_roll
	
# rolls the dice for opponent
func opp_roll():
	dice_roll = int(floor(rng.randf_range(1,7)))
	# dice_roll = int(floor(rng.randf_range(1,3)))
	# instead of changing text, would change sprite here
	opp_dice_roll.text = str(dice_roll)
	# return dice_roll

func player_turn():
	# start dice rolling animation here
	await get_tree().create_timer(1).timeout
	player_roll()
	player_input = true # set to true when player can go

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
	
	# player column calculations
	var player_score_col_0 = count_die(player_grid, 0)
	var player_score_col_1 = count_die(player_grid, 1)
	var player_score_col_2 = count_die(player_grid, 2)
	# total score (peak variable name right here...)
	player_total_score = player_score_col_0 + player_score_col_1 + player_score_col_2
	
	# update player score labels
	player_score_0.text = str(player_score_col_0)
	player_score_1.text = str(player_score_col_1)
	player_score_2.text = str(player_score_col_2)
	player_score_total.text = str(player_total_score)
	
	# opponent column calculations
	var opp_score_col_0 = count_die(opp_grid, 0)
	var opp_score_col_1 = count_die(opp_grid, 1)
	var opp_score_col_2 = count_die(opp_grid, 2)
	# total score (peak variable name right here...)
	opp_total_score = opp_score_col_0 + opp_score_col_1 + opp_score_col_2
	
	# update player score labels
	opp_score_0.text = str(opp_score_col_0)
	opp_score_1.text = str(opp_score_col_1)
	opp_score_2.text = str(opp_score_col_2)
	opponent_score_total.text = str(opp_total_score)

# find score of the provided column
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


# im hard-coding this idc :skull:
func shift_up(grid, col):
	# if first and second are 0, swap first with end
	# 001
	if grid[0][col] == 0 && grid[1][col] == 0 && grid[2][col] > 0:
		grid[0][col] = grid[2][col]
		grid[2][col] = 0
	
	# if first is zero, second is not zero, and third is zero, swap first and second
	# 010
	if grid[0][col] == 0 && grid[1][col] > 0 && grid[2][col] == 0:
		grid[0][col] = grid[1][col]
		grid[1][col] = 0
	
	# if first is zero, second is not zero, and third is not zero, SHIFT zero to end
	# 011
	if grid[0][col] == 0 && grid[1][col] > 0 && grid[2][col] > 0:
		grid[0][col] = grid[1][col]
		grid[1][col] = grid[2][col]
		grid[2][col] = 0
	
	# if first is not zero, second is zero, and third is not zero, swap second with third
	# 101
	if grid[0][col] > 0 && grid[1][col] == 0 && grid[2][col] > 0:
		grid[1][col] = grid[2][col]
		grid[2][col] = 0

	return grid

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
			for i in range(3):
				if opp_grid[i][0] == dice_roll:
					opp_grid[i][0] = 0
			# shift up function
			opp_grid = shift_up(opp_grid, 0)
			
			update_all()

			# set player_input to false so player can't click anymore
			player_input = false
			
			var zeroes_left = true
			if !player_grid[0].has(0) && !player_grid[1].has(0) && !player_grid[2].has(0):
				zeroes_left = false
			
			# if board is not full, continue playing
			if zeroes_left:
				opp_turn()
			# otherwise, end game and declare winner
			else:
				get_node("../GameOver").game_over()


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
			for i in range(3):
				if opp_grid[i][1] == dice_roll:
					opp_grid[i][1] = 0
			# shift up function
			opp_grid = shift_up(opp_grid, 1)
			update_all()
			
			# set player_input to false so player can't click anymore
			player_input = false
			
			var zeroes_left = true
			if !player_grid[0].has(0) && !player_grid[1].has(0) && !player_grid[2].has(0):
				zeroes_left = false
			
			# if board is not full, continue playing
			if zeroes_left:
				opp_turn()
			# otherwise, end game and declare winner
			else:
				get_node("../GameOver").game_over()


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
			for i in range(3):
				if opp_grid[i][2] == dice_roll:
					opp_grid[i][2] = 0
			# shift up function
			opp_grid = shift_up(opp_grid, 2)
			
			update_all()
			# if board is not full, continue playing
				# set player_input to false so player can't click anymore
			player_input = false
			
			var zeroes_left = true
			if !player_grid[0].has(0) && !player_grid[1].has(0) && !player_grid[2].has(0):
				zeroes_left = false
			
			# if board is not full, continue playing
			if zeroes_left:
				opp_turn()
			# otherwise, end game and declare winner
			else:
				get_node("../GameOver").game_over()


func opp_turn():
	# start dice rolling animation here
	await get_tree().create_timer(1).timeout
	opp_roll()
	
	# variable to break out of nested loops and prevent dice from being placed multiple times
	var broke = false

	# check if player has multiple dice in same column
	for i in range(3):
		# if 3 in player column
		if [player_grid[0][i], player_grid[1][i], player_grid[2][i]].count(dice_roll) > 2 and [opp_grid[0][i], opp_grid[1][i], opp_grid[2][i]].count(0) > 0:
			# remove from player board and shift up
			if player_grid[0][i] == dice_roll:
				player_grid[0][i] = 0
			if player_grid[1][i] == dice_roll:
				player_grid[1][i] = 0
			if player_grid[2][i] == dice_roll:
				player_grid[2][i] = 0
			player_grid = shift_up(player_grid, i)
				
			# place in opp board
			for j in range(3):
				if opp_grid[j][i] == 0:
					opp_grid[j][i] = dice_roll
					broke = true
					break
		# if 2 in player column
		elif [player_grid[0][i], player_grid[1][i], player_grid[2][i]].count(dice_roll) > 1 and [opp_grid[0][i], opp_grid[1][i], opp_grid[2][i]].count(0) > 0:
			# remove from player board and shift up
			if player_grid[0][i] == dice_roll:
				player_grid[0][i] = 0
			if player_grid[1][i] == dice_roll:
				player_grid[1][i] = 0
			if player_grid[2][i] == dice_roll:
				player_grid[2][i] = 0
			player_grid = shift_up(player_grid, i)
				
			# place in opp board
			for j in range(3):
				if opp_grid[j][i] == 0:
					opp_grid[j][i] = dice_roll
					broke = true
					break
		# if 1 in player column (won't implement so that game doesn't get too difficult/tedious...)
		
		# break out of loop
		if broke:
			break
	
	# check if dice matches dice in current column
	if !broke:
		for i in range(3):
			if [opp_grid[0][i], opp_grid[1][i]].count(dice_roll) == 2 and [opp_grid[0][i], opp_grid[1][i], opp_grid[2][i]].count(0) > 0:
				# remove from player board and shift up
				if player_grid[0][i] == dice_roll:
					player_grid[0][i] = 0
				if player_grid[1][i] == dice_roll:
					player_grid[1][i] = 0
				if player_grid[2][i] == dice_roll:
					player_grid[2][i] = 0
				player_grid = shift_up(player_grid, i)
				
				# place in opp board
				for j in range(3):
					if opp_grid[j][i] == 0:
						opp_grid[j][i] = dice_roll
						broke = true
						break
			elif [opp_grid[0][i], opp_grid[1][i]].count(dice_roll) == 1 and [opp_grid[0][i], opp_grid[1][i], opp_grid[2][i]].count(0) > 0:
				# remove from player board and shift up
				if player_grid[0][i] == dice_roll:
					player_grid[0][i] = 0
				if player_grid[1][i] == dice_roll:
					player_grid[1][i] = 0
				if player_grid[2][i] == dice_roll:
					player_grid[2][i] = 0
				player_grid = shift_up(player_grid, i)
				
				# place in opp board
				for j in range(3):
					if opp_grid[j][i] == 0:
						opp_grid[j][i] = dice_roll
						broke = true
						break
			if broke:
				break
	
	# only run if only option
	if !broke:
		# randomly decide opp column for now (use timer)
		for i in range(3):
			for j in range(3):
				if opp_grid[i][j] == 0:
					opp_grid[i][j] = dice_roll
					
					# function for eliminating dice on player side
					for k in range(3):
						if player_grid[k][j] == dice_roll:
							player_grid[k][j] = 0
					
					# shift up function
					player_grid = shift_up(player_grid, j)
					# used to break out of nested for loop
					broke = true
					break
			if broke:
				break

	# calculate and update column score and total score
	update_all()
	
	var zeroes_left = true
	if !opp_grid[0].has(0) && !opp_grid[1].has(0) && !opp_grid[2].has(0):
		zeroes_left = false
	
	# if board is not full, continue playing
	if zeroes_left:
		player_turn()
	# otherwise, end game and declare winner
	else:
		get_node("../GameOver").game_over()
