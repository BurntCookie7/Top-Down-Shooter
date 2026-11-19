extends Node

enum State{WALKING, RUNNING, SITTING, STANDING}
var can_sit: bool = false
var upgrade_menu
var enemy_drop_chance: Vector2 = Vector2(1,3)
var map_scene: PackedScene
var enemies_killed: int = 0
var won_round: bool = false
var player_health: int = 100
var player_max_health: int = 100
var player: Node2D
var map_container: Node
var map: Node2D
var wins: int = 1
var cycle: int = 0
var rounds: int = 5
var loops: int = 1
var player_max_grenades = 3
var player_control_mode: String = "Mouse_Turn"
var enemy_damage_mult = 1.0
var enemy_health_mult = 2.0
var arachnophobia: bool = false
var benches: int = 1
var upgrades: int = 3
var ammo_per_pickup: int = 5
var enemies_active: bool
var grenade_scene: PackedScene = preload("res://Grenade.tscn")
var canvas_layer = null
var turn_sensitivity: float = 1.0
var upgrade_reroll_chance = 0.0
#var global_path = ProjectSettings.globalize_path("res://")
var save_path = "user://SaveData.cfg"
var egg_bombers_killed: int = 0
var area_bombers_killed: int = 0
var grenade_radius: int = 0
var unlocks: Dictionary[StringName, bool] = {
	"BasicGrenade": true,
	"BabySpider": false,
	"AreaGrenade": false
	}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists("user://SaveData.cfg"):
		pass
	else:
		var config_file = ConfigFile.new()
		config_file.save(save_path)
	load_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func wait(frames: int):
	for i in range(frames):
		await get_tree().physics_frame

func _physics_process(delta: float) -> void:
	pass

func restart():
	can_sit = false
	upgrade_menu
	enemies_killed = 0
	won_round = false
	player_health = 100
	player_max_health = 100
	wins = 1
	cycle = 0
	rounds = 5
	loops = 1
	player_max_grenades = 3
	upgrades = 3
	upgrade_reroll_chance = 0.0
	player.grenades = player_max_grenades
	player.ammunition_remaining = player.max_ammunition
	#map_container.load_new_map(map_container.initial_map)
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#get_tree().reload_current_scene()
	
func save_game():
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for node in save_nodes:
	
	for key in unlocks:
			save_value("Unlocks", key, unlocks[key])
	
	save_value("Player", "grenade_scene", grenade_scene.resource_path)
	save_value("Player", "EggBombersKilled", egg_bombers_killed)
	save_value("Player", "AreaBombersKilled", area_bombers_killed)
	

func save_value(section, key, variant):
	var config = ConfigFile.new()
	config.load(save_path)
	config.set_value(section, key, variant)
	config.save(save_path)
	
func load_game():
	var config = ConfigFile.new()
	if config.load(save_path) != OK:
		return #no save
	
	grenade_scene = load(config.get_value("Player", "grenade_scene"))
	egg_bombers_killed = config.get_value("Player", "EggBombersKilled", egg_bombers_killed)
	area_bombers_killed = config.get_value("Player", "AreaBombersKilled", area_bombers_killed)
	
	for unlock in unlocks:
		unlocks[unlock] = config.get_value("Unlocks", unlock, unlocks[unlock])
	
	
