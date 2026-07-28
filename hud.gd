extends CanvasLayer

@onready var health_label: Label = $HealthLabel
@onready var wave_label: Label = $WaveLabel   
@onready var score_label: Label = $ScoreLabel 

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	if GameManager:
		GameManager.connect("score_changed", Callable(self, "_on_score_changed"))
		GameManager.connect("wave_changed", Callable(self, "_on_wave_changed"))
	else:
		printerr("FATAL ERROR: GameManager belum terdaftar di Autoload!")

func update_health_display(current_health: int) -> void:
	if is_instance_valid(health_label):
		health_label.text = "Health: " + str(current_health)

func _on_score_changed(new_score: int) -> void:
	if is_instance_valid(score_label):
		score_label.text = "Score: " + str(new_score)

func _on_wave_changed(wave: int, max_w: int) -> void:
	if is_instance_valid(wave_label):
		wave_label.text = "Wave: " + str(wave) + " / " + str(max_w)
