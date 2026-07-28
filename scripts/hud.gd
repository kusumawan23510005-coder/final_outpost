extends CanvasLayer

@onready var health_label: Label = $HealthLabel
@onready var wave_label: Label = $WaveLabel   
@onready var score_label: Label = $ScoreLabel 

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	if GameManager:
		
		if GameManager.has_signal("health_changed"):
			if not GameManager.health_changed.is_connected(_on_health_changed):
				GameManager.health_changed.connect(_on_health_changed)
	
			_on_health_changed(GameManager.health)

		
		if GameManager.has_signal("score_changed") and not GameManager.score_changed.is_connected(_on_score_changed):
			GameManager.score_changed.connect(_on_score_changed)
			
		if GameManager.has_signal("wave_changed") and not GameManager.wave_changed.is_connected(_on_wave_changed):
			GameManager.wave_changed.connect(_on_wave_changed)
	else:
		printerr("FATAL ERROR: GameManager belum terdaftar di Autoload!")

func _on_health_changed(current_health: int) -> void:
	if is_instance_valid(health_label):
		health_label.text = "Health: " + str(current_health)

func _on_score_changed(new_score: int) -> void:
	if is_instance_valid(score_label):
		score_label.text = "Score: " + str(new_score)

func _on_wave_changed(wave: int, max_w: int) -> void:
	if is_instance_valid(wave_label):
		wave_label.text = "Wave: " + str(wave) + " / " + str(max_w)
