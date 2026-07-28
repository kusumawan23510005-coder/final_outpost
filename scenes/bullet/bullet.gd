extends Area2D

@export var speed: float = 800.0
@export var damage: int = 1

func _ready() -> void:

	if not body_entered.is_connected(_on_body_entered):
		var error = body_entered.connect(_on_body_entered)
		if error != OK:
			printerr("GAGAL: Tidak dapat menghubungkan sinyal body_entered pada peluru!")

func _physics_process(delta: float) -> void:
	
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("DEBUG: Peluru menabrak objek -> ", body.name)
	

	if body.has_method("take_damage"):
		body.take_damage(damage)
		print("DEBUG: Damage berhasil dikirim ke ", body.name)
	else:
		print("WARNING: Objek yang ditabrak tidak memiliki fungsi take_damage!")
	
	
	queue_free()
