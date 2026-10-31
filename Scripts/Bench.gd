extends StaticBody2D
@onready var area_2d: Area2D = $Area2D
@onready var sitting_pos: Node2D = $SittingPos

@export var Upgrades_Menu: PackedScene
@export var Upgrade_Button: PackedScene
@export var hit_color: Color
@export var upgrade_options: Array[UpgradeData]

var menu_made: bool
var menu = null
var player: Node2D = null
signal upgrade_chosen(upgrade:UpgradeData, player_node:Node2D)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.can_sit = true
		SignalBus.player_entered_bench.emit(self, sitting_pos.global_position)
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.can_sit = false

func load_upgrades(upgrades: Array[UpgradeData]):
	if menu_made:
		menu.show()
		menu.global_rotation = player.camera.global_rotation - deg_to_rad(90)
		menu.global_position = player.global_position
		menu.global_position.y -= 200
		#print("menu shown")
	else:
		menu = Upgrades_Menu.instantiate()
		menu.name = "UpgradeMenu"
		add_child(menu)
		menu.global_rotation = player.camera.global_rotation - deg_to_rad(90)
		menu.global_position = player.global_position
		menu.global_position.y -= 200
		var Hbox = menu.get_child(0)
		for upgrade in upgrades:
			var option = Upgrade_Button.instantiate()
			option.setup(upgrade)
			option.pressed.connect(func():
				upgrade_chosen.emit(upgrade, player)
				player.apply_upgrade(upgrade))
			Hbox.add_child(option)
		for child in menu.get_children():
			child.z_index = 500
		menu_made = true
		#print("menu shown")
		
func unload_upgrades():
	menu.hide()
	
func remove_upgrades():
	menu.queue_free()
