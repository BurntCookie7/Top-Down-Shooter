extends Control
@onready var ammo: Label = $Ammo
@onready var reserves: Label = $Reserves 
@onready var health_bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label
@onready var round_counter: Label = $RoundCounter
@onready var grenades_label: Label = $Label
@onready var consumables_container: HBoxContainer = $ConsumablesContainer
@onready var consumables: Array[Node] = consumables_container.get_children()
var selected_consumable: Node
var selected_style = preload("res://Styles/ConsumablePanelSelected.tres")
var default_style = preload("res://Styles/ConsumablePanel.tres")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("F"):
		if not Global.player.in_menu:
			if Global.player.active_consumable == null:
				if is_instance_valid(selected_consumable):
					if selected_consumable.quantity > 0:
						Global.player.apply_consumable(selected_consumable.data)
						selected_consumable.quantity -= 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_ui = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.enemies_active:
		round_counter.show()
	else:
		round_counter.hide()
	
func _physics_process(delta: float) -> void:
	handle_consumable_selection()
	ammo.text = "Ammo: " + str(Global.player.ammunition_remaining) + "/" + str(Global.player.max_ammunition)
	reserves.text = "Reserves: " + str(Global.player.reserves)
	health_bar.max_value = Global.player_max_health
	label.text = str(Global.player_health)
	health_bar.value = Global.player_health
	round_counter.text = "Round: " + str(Global.wins) + "/5"
	grenades_label.text = "Grenades: " + str(Global.player.grenades) + "/" + str(int(Global.player_max_grenades))

func manual_update():
	ammo.text = "Ammo: " + str(Global.player.ammunition_remaining) + "/" + str(Global.player.max_ammunition)
	reserves.text = "Reserves: " + str(Global.player.reserves)
	health_bar.max_value = Global.player_max_health
	label.text = str(Global.player_health)
	health_bar.value = Global.player_health
	round_counter.text = "Round: " + str(Global.wins) + "/5"
	grenades_label.text = "Grenades: " + str(Global.player.grenades) + "/" + str(int(Global.player_max_grenades))



func handle_consumable_selection():
	for i in consumables.size():
		if Global.player.selection_index == i:
			if "selected" in consumables[i]:
				consumables[i].selected = true
				if is_instance_valid(consumables[i].background):
					consumables[i].background.add_theme_stylebox_override("panel", selected_style)
				selected_consumable = consumables[i] 
		else:
			if is_instance_valid(consumables[i].background):
				consumables[i].background.add_theme_stylebox_override("panel", default_style)
