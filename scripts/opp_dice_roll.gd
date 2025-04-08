extends Label

var rng = RandomNumberGenerator.new()

var dice_roll = 0
@onready var opp_dice_roll: Label = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opp_roll()
	pass # Replace with function body.

# rolls the dice for player
func opp_roll():
	dice_roll = int(floor(rng.randf_range(1,7)))
	opp_dice_roll.text = str(dice_roll)
