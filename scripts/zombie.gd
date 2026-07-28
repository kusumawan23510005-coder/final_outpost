class_name Zombie
extends CharacterBody2D

signal zombie_died

@export var base_speed: float = 40.0
@export var run_speed_multiplier: float = 2.2
@export var attack_distance: float = 60.0
@export var max_health: int = 3
@export var attack_damage: int = 1
@export var attack_cooldown: float = 1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D as CollisionShape2D

var move_speed: float = 0.0
var player_node: Node2D = null
var current_health: int = 0
var attack_timer: float = 0.0
var is_dead: bool = false
var is_runner: bool = false

func _ready() -> void:
	assert(animated_sprite != null, "Prasyarat Gagal: AnimatedSprite2D tidak ditemukan!")
	assert(collision_shape != null, "Prasyarat Gagal: CollisionShape2D tidak ditemukan!")

	_setup_zombie_stats()

func _setup_zombie_stats() -> void:
	is_runner = randf() < 0.3
	if is_runner:
		move_speed = (base_speed * run_speed_multiplier) + randf_range(-5.0, 15.0)
		max_health = 2
	else:
		move_speed = base_speed + randf_range(-10.0, 15.0)
	
	current_health = max_health

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	_find_player_if_needed()

	if not is_instance_valid(player_node):
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction_to_player: Vector2 = global_position.direction_to(player_node.global_position)
	var distance_to_player: float = global_position.distance_to(player_node.global_position)

	if attack_timer > 0.0:
		attack_timer -= delta

	if distance_to_player > attack_distance:
		velocity = direction_to_player * move_speed
		_update_movement_animation(direction_to_player)
	else:
		velocity = Vector2.ZERO
		_handle_attack(direction_to_player)

	move_and_slide()

func _find_player_if_needed() -> void:
	if not is_instance_valid(player_node):
		var players := get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player_node = players[0] as Node2D

func _update_movement_animation(direction: Vector2) -> void:
	if not is_instance_valid(animated_sprite):
		return
	
	animated_sprite.play("run" if is_runner else "walk")
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0

func _handle_attack(direction: Vector2) -> void:
	if not is_instance_valid(animated_sprite):
		return
		
	animated_sprite.play("attack")
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0

	if attack_timer <= 0.0:
		if is_instance_valid(player_node) and player_node.has_method("take_damage"):
			player_node.take_damage(attack_damage)
		attack_timer = attack_cooldown

func take_damage(amount: int) -> void:
	if is_dead or amount <= 0:
		return

	current_health = clampi(current_health - amount, 0, max_health)

	if current_health == 0:
		_die()

func _die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO

	collision_shape.set_deferred("disabled", true)

	# Emit sinyal kematian & tambah skor secara langsung tanpa menanti animasi usai
	var gm = get_node_or_null("/root/GameManager")
	if gm and gm.has_method("add_score"):
		gm.add_score(100)

	zombie_died.emit()

	if is_instance_valid(animated_sprite) and animated_sprite.sprite_frames.has_animation("dead"):
		animated_sprite.play("dead")
		await animated_sprite.animation_finished

	queue_free()
