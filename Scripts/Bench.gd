extends StaticBody2D
@onready var area_2d: Area2D = $Area2D
@onready var sitting_pos: Node2D = $SittingPos

@export var Upgrades_Menu: PackedScene
@export var Upgrade_Button: PackedScene
@export var hit_color: Color
@export var upgrade_table: BenchTable

var menu_made: bool
var menu = null
var player: Node2D = Global.player
signal upgrade_chosen(upgrade:UpgradeData, player_node:Node2D, button)
var upgrade_options: Array[UpgradeData]
var buffer_node: Control
var Hbox: Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESC") and player.sitting:
		menu_made = false
		unload_upgrades()
		upgrade_options.clear()
		remove_upgrades()
		load_upgrades()

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

func load_upgrades():
	if menu_made:
		menu.show()
		menu.global_rotation = player.camera.global_rotation - deg_to_rad(90)
		menu.global_position = player.global_position
		menu.global_position.y -= 100
		#print("menu shown")
	else:
		menu = Upgrades_Menu.instantiate()
		Hbox = menu.get_child(-1).get_child(0)
		menu.name = "UpgradeMenu"
		add_child(menu)
		menu.global_rotation = player.camera.global_rotation - deg_to_rad(90)
		menu.global_position = player.global_position
		menu.global_position.y -= 100
		for upgrade in Global.upgrades:
			create_button()
		for child in menu.get_children():
			child.z_index = 500
		buffer_node = Control.new()
		Hbox.add_child(buffer_node)
		Hbox.move_child(buffer_node, -1)
		menu_made = true
		
		#print("menu shown")

func create_button():
	var option = Upgrade_Button.instantiate()
	var upgrade_choice = upgrade_table.pick_random()
	option.setup(upgrade_choice)
	var tries = 0
	while option.data in upgrade_options and tries <= 10:
		option.setup(upgrade_table.pick_random())
		tries += 1
		continue
	if tries > 10:
		upgrade_choice = upgrade_table.pick_random()
	else:
		upgrade_choice = option.data
	option.pressed.connect(func():
		var button = option
		upgrade_chosen.emit()
		player.apply_upgrade(upgrade_choice, button))
		
	Hbox.add_child(option)
	var option_button := option.get_node("Button") as Button
	option_button.gui_input.connect(func(event: InputEvent):
		print("[bench] gui_input on button: ", event)
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			option_button.accept_event()
			trash_upgrade(option))
	upgrade_options.append(option.data)
	return

func trash_upgrade(button):
	if buttons_remaining() <= 1:
		Global.player.finish_bench()
		return
	upgrade_options.erase(button.data)
	button.queue_free()

func buttons_remaining() -> int:
	var count = 0
	for child in Hbox.get_children():
		if child != buffer_node and not child.is_queued_for_deletion():
			count += 1
	return count
	

func unload_upgrades():
	menu.hide()
	
func remove_upgrades():
	menu.queue_free()
