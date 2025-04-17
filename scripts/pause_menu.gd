extends Control

func _ready():
	hide()

func _process(delta: float):
	testEsc()

func resume():
	hide()
	get_tree().paused = false

func pause():
	show()
	get_tree().paused = true

func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
