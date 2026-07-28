extends Control

@onready var score_label: Label = $ScoreLabel
@onready var restart_button: Button = $RestartButton

func _ready() -> void:
	
	if is_instance_valid(score_label) and GameManager:
		score_label.text = "Skor Akhir: " + str(GameManager.score)
		
	
	if is_instance_valid(restart_button):
		restart_button.pressed.connect(_on_restart_button_pressed)

func _on_restart_button_pressed() -> void:
	
	if GameManager:
		GameManager.reset_game()
		
	get_tree().change_scene_to_file("res://main.tscn")
