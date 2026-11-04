extends CharacterBody2D
@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var raycast: RayCast2D = $Sprite2D/RayCast2D
@onready var bullet_spawn_position: Node2D = $Sprite2D/BulletSpawnPosition
@export var SPEED: float = 100.0
@export var drops: DropTable
@export var total_health: int = 100.0
@onready var sprite: LitAnimatedSprite2D = $Sprite2D
@export var hit_color: Color = Color()
@export var bullet_scene: PackedScene
@export var damage: int = 5
@onready var health_bar: ProgressBar = $Node2D/ProgressBar
var health: int
var health_bar_offset: Vector2 = Vector2(13, -20)

func _ready() -> void:
	await get_tree().physics_frame
	update_target()
	health = total_health
	health_bar.top_level = true
	sprite.play()

func _physics_process(delta: float) -> void:
	manage_health()
	if navigation.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	health_bar.global_position = global_position + health_bar_offset
	var next_position := navigation.get_next_path_position()
	var direction := global_position.direction_to(next_position)
	velocity = direction * SPEED
	rotation = direction.angle()
	#manage_shooting()
	move_and_slide()

func _on_timer_timeout() -> void:
	update_target()
	

func hit():
	modulate = Color(1.0, 0.0, 0.0, 1.0)
	await Global.wait(3)
	modulate = Color(1.0, 1.0, 1.0, 1.0)

func update_target():
	if is_instance_valid(player):
		navigation.target_position = player.global_position
		
func manage_health():
	health_bar.value = health
	if health <= 0:
		var drop: Node2D = drop_item(drops.table).instantiate()
		Global.map.add_child(drop)
		drop.global_position = global_position
		drop.rotation = randf()
		Global.enemies_killed += 1
		queue_free()

func drop_item(table: Dictionary):
	var total = 0.0
	for weight in table.values():
		total += weight
	
	var roll: float = randf() * total
	
	for item in table:
		roll -= table[item]
		if roll <= 0.0:
			return item
	
	return null

func shoot():
	var bullet: Area2D = bullet_scene.instantiate()
	bullet.collision_layer = 2
	bullet.collision_mask = 2
	bullet.shot_by_enemy = true
	bullet.damage = damage
	bullet.rotation_degrees = rotation_degrees
	get_tree().root.add_child(bullet)
	bullet.global_position = bullet_spawn_position.global_position

func manage_shooting():
	if is_instance_valid(bullet_scene):
		if raycast.is_colliding():
			var target = raycast.get_collider()
			if is_instance_valid(target):
				if target.is_in_group("Player"):
					shoot()


func _on_shoot_timer_timeout() -> void:
	manage_shooting()
