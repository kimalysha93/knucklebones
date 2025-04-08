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

var opp_grid = [
	[0,0,0],
	[0,0,0],
	[0,0,0],]

@onready var game_manager: Node = $"."
@onready var player_dice_roll: Label = $DiceLabels/PlayerDiceRoll
@onready var opp_dice_roll: Label = $DiceLabels/OppDiceRoll
@onready var roll_timer: Timer = $"../RollTimer"


func _ready() -> void:
	if turn:
		player_turn()
	else:
		opp_turn()

# rolls the dice for player
func player_roll():
	dice_roll = int(floor(rng.randf_range(1,7)))
	# instead of changing text, would change sprite here
	player_dice_roll.text = str(dice_roll)
	return dice_roll
	
# rolls the dice for opponent
func opp_roll():
	dice_roll = int(floor(rng.randf_range(1,7)))
	# instead of changing text, would change sprite here
	opp_dice_roll.text = str(dice_roll)
	return dice_roll


func player_turn():
	# start dice rolling animation here
	await get_tree().create_timer(2).timeout
	var roll = player_roll()
	player_input = true
	print("player: "+str(roll))
	
	# wait for player input to select column
	
	
	# add dice to selected column
	
	
	# calculate and update column score and total score
	
	# if board is not full, continue playing
	opp_turn()
	# otehrwise, end game and declare winner

func opp_turn():
	# start dice rolling animation here
	await get_tree().create_timer(2).timeout
	var roll = opp_roll()
	print("opponent: "+str(roll))
	
	# randomly decide opp column for now (use timer)
	
	# calculate and update column score and total score
	
	# if board is not full, continue playing
	player_turn()
	# otehrwise, end game and declare winner
