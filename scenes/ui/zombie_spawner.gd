extends Node2D

@export var zombie_scene: PackedScene

@export_group("Wave Settings")
@export var max_waves: int = 6
@export var base_zombies_per_wave: int = 4
@export var spawn_delay: float = 0.8
@export var wave_delay: float = 5.0

@export_group("Spawn Variation")
@export var y_spawn_offset: float = 30.0

@onready var spawn_points: Array[Node] = [$SpawnPoint, $SpawnPoint2, $SpawnPoint3]

var current_wave: int = 0
var is_wave_active: bool = false
var zombies_spawned_count: int = 0
var zombies_remaining_count: int = 0

func _ready() -> void:
	start_next_wave()

func start_next_wave() -> void:
	if current_wave >= max_waves:
		print("--- GAME SELESAI: SEMUA WAVE TELAH TERLEWATI! PEMAIN MENANG! ---")
		get_tree().change_scene_to_file("res://scenes/ui/victory.tscn")
		return
		
	current_wave += 1
	GameManager.set_wave(current_wave, max_waves)
	print(">>> MEMULAI WAVE: ", current_wave, " / ", max_waves, " <<<")
	
	var total_zombies_this_wave: int = base_zombies_per_wave + ((current_wave - 1) * 2)
	zombies_spawned_count = total_zombies_this_wave
	zombies_remaining_count = total_zombies_this_wave
	
	_run_wave_routine(total_zombies_this_wave)

func _run_wave_routine(zombie_count: int) -> void:
	is_wave_active = true
	
	for i in range(zombie_count):
		_spawn_single_zombie()
		await get_tree().create_timer(spawn_delay).timeout
	
	is_wave_active = false
	print("Semua zombie di Wave ", current_wave, " selesai di-spawn. Menunggu pemain membasmi sisanya...")

func _spawn_single_zombie() -> void:
	if not zombie_scene:
		printerr("CRITICAL ERROR: 'zombie.tscn' belum dimasukkan ke Inspector ZombieSpawner!")
		return

	var random_point: Node2D = spawn_points.pick_random() as Node2D
	if is_instance_valid(random_point):
		var new_zombie = zombie_scene.instantiate() as Node2D
		var spawn_pos: Vector2 = random_point.global_position
		spawn_pos.y += randf_range(-y_spawn_offset, y_spawn_offset)
		new_zombie.global_position = spawn_pos
		
		if new_zombie.has_signal("zombie_died"):
			new_zombie.connect("zombie_died", Callable(self, "_on_zombie_died"))
		
		get_parent().add_child.call_deferred(new_zombie)

func _on_zombie_died() -> void:
	zombies_remaining_count -= 1
	print("Zombie tumbrok! Sisa zombie di wave ini: ", zombies_remaining_count)
	
	if zombies_remaining_count <= 0 and not is_wave_active:
		
		if current_wave >= max_waves:
			start_next_wave()
		else:
			print("Wave ", current_wave, " BERHASIL DITAKLUKKAN! Jeda ", wave_delay, " detik...")
			await get_tree().create_timer(wave_delay).timeout
			start_next_wave()
