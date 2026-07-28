extends Control


@onready var score_label: Label = $ScoreLabel
@onready var restart_button: Button = $RestartButton

const MAIN_SCENE_PATH: String = "res://scenes/main/main.tscn"

func _ready() -> void:
	
	get_tree().paused = false
	
	if is_instance_valid(score_label) and GameManager:
		score_label.text = "Skor Akhir: " + str(GameManager.score)
		
	if is_instance_valid(restart_button):
		
		if not restart_button.pressed.is_connected(_on_restart_button_pressed):
			restart_button.pressed.connect(_on_restart_button_pressed)

func _on_restart_button_pressed() -> void:
	if GameManager:
		GameManager.reset_game()
		
	if ResourceLoader.exists(MAIN_SCENE_PATH):
		var err: Error = get_tree().change_scene_to_file(MAIN_SCENE_PATH)
		if err != OK:
			push_error("Gagal mengganti scene. Kode Error: " + str(err))
	else:
		push_error("File scene tidak ditemukan di path: " + MAIN_SCENE_PATH)
