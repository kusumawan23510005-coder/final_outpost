extends CharacterBody2D

signal health_changed(new_health: int)

@export var walk_speed: float = 200.0
@export var run_speed: float = 350.0
@export var max_health: int = 5
var current_health: int = 0
var is_dead: bool = false 

@export var fire_rate: float = 0.15 
var fire_timer: float = 0.0

@export var bullet_scene: PackedScene = load("res://scenes/bullet/bullet.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle

func _ready() -> void:
	add_to_group("player")
	current_health = max_health
	
	# Sinkronkan nilai darah awal ke GameManager & HUD
	if GameManager:
		GameManager.health = current_health
		GameManager.max_health = max_health
		if GameManager.has_signal("health_changed"):
			GameManager.health_changed.emit(current_health)
			
	health_changed.emit(current_health)

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction: Vector2 = Input.get_vector("kiri", "kanan", "atas", "bawah")
	
	var is_running: bool = Input.is_key_pressed(KEY_SHIFT)
	var current_speed: float = run_speed if is_running else walk_speed
	
	velocity = direction * current_speed
	
	if fire_timer > 0:
		fire_timer -= delta

	if Input.is_action_pressed("shoot"):
		if fire_timer <= 0:
			_fire_bullet()
			fire_timer = fire_rate
			
		if is_instance_valid(animated_sprite):
			animated_sprite.play("shoot")
	else:
		if velocity != Vector2.ZERO:
			if is_instance_valid(animated_sprite):
				if is_running:
					animated_sprite.play("run")
				else:
					animated_sprite.play("walk")
					
				if direction.x != 0:
					animated_sprite.flip_h = direction.x < 0
		else:
			if is_instance_valid(animated_sprite):
				animated_sprite.play("idle")
			
	move_and_slide()

func _fire_bullet() -> void:
	if not bullet_scene:
		printerr("GAGAL: Bullet Scene tidak ditemukan di jalur yang ditentukan!")
		return
		
	var bullet_instance = bullet_scene.instantiate() as Node2D
	bullet_instance.global_position = muzzle.global_position
	
	var mouse_position := get_global_mouse_position()
	var shoot_direction := (mouse_position - muzzle.global_position).normalized()
	bullet_instance.rotation = shoot_direction.angle()
	
	get_tree().current_scene.add_child(bullet_instance)

func take_damage(amount: int) -> void:
	if is_dead:
		return 
		
	current_health -= amount
	current_health = max(0, current_health)
	
	# PENTING: Meneruskan pembaruan damage ke GameManager agar HUD terbarui!
	if GameManager:
		GameManager.take_damage(amount)
		
	health_changed.emit(current_health)
	print("WARNING: Player terkena serangan! Sisa darah: ", current_health)
	
	if current_health <= 0:
		_die()

func _die() -> void:
	if is_dead:
		return
	is_dead = true
	
	print("KONDISI FATAL: PEMAIN MATI, MENUNGGU ANIMASI SELESAI...")
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	if is_instance_valid(animated_sprite):
		animated_sprite.play("dead")
		await animated_sprite.animation_finished
		
	get_tree().change_scene_to_file("res://scenes/ui/gameover.tscn")
