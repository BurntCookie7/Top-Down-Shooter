extends Control

@onready var Hbox: HBoxContainer = $Panel/Panel/ScrollContainer/Control
@onready var inspector: Panel = $Panel/Inspector
@onready var continue_button: Button = $Panel/Inspector/Continue
@onready var gems_balance: Label = $Panel/Gems/Label

@export var upgrade_button: PackedScene
@export var upgrade_table: BenchTable

var upgrade_options: Array[UpgradeData]
var option = null
var chosen_upgrade = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_options.clear()
	for i in range(Global.upgrades):
		create_button()
	Hbox.add_child(Control.new())
	gems_balance.text = str(Global.gem_balance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
