extends Control

@onready var Hbox: HBoxContainer = $Panel/Panel/ScrollContainer/Control
@onready var inspector: Panel = $Panel/Inspector
@onready var continue_button: Button = $Panel/Inspector/Continue
@onready var gems_balance: Label = $Panel/Gems/Label
@onready var ConsumableHbox: HBoxContainer = $Panel/Consumables/ScrollContainer/Control

@export var upgrade_button: PackedScene
@export var upgrade_table: BenchTable
@export var consumable_button: PackedScene
@export var consumable_options: Array[ConsumableData]

var upgrade_options: Array[UpgradeData]
var option = null
var chosen_upgrade = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_options.clear()
	for i in range(Global.upgrades):
		create_button()
	create_consumable_buttons()
	Hbox.add_child(Control.new())
	Global.player.in_menu = true
	Global.player.state = Global.State.SITTING
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gems_balance.text = str(Global.gem_balance)

func create_button():
	var data: UpgradeData = upgrade_table.pick_random()
	
	var tries = 0
	while data in upgrade_options and tries <= 40:
		data = upgrade_table.pick_random()
		tries += 1
	
	upgrade_options.append(data)
	
	option = upgrade_button.instantiate()
	option.setup(data)
	option.selected.connect(inspector.button_selected)
	Hbox.add_child(option)
	
func create_consumable_buttons():
	for i in consumable_options.size():
		var button_instance = consumable_button.instantiate()
		button_instance.setup(consumable_options[i])
		ConsumableHbox.add_child(button_instance)
		button_instance.selected.connect(inspector.button_selected)
