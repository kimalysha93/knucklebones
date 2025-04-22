extends CanvasLayer
@onready var label: Label = $Label

func _ready():
	self.hide()

func _on_play_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func game_over():
	get_tree().paused = true
	var player_score = int(get_node("../GameManager/ScoreLabels/PlayerScoreTotal").text)
	var opponent_score = int(get_node("../GameManager/ScoreLabels/OpponentScoreTotal").text)
	if player_score > opponent_score:
		label.text = "Player Wins\n"+str(player_score)+"  -  "+str(opponent_score)
	if opponent_score > player_score:
		label.text = "Opponent Wins\n"+str(opponent_score)+"  -  "+str(player_score)
	if player_score == opponent_score:
		label.text = "It's a Draw\n"+str(player_score)+"  -  "+str(opponent_score)

	self.show()
