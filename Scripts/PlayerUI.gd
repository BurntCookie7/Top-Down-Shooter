extends Control
@onready var ammo: Label = $Ammo
@onready var reserves: Label = $Reserves 
@onready var health_bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label
@onready var round_counter: Label = $RoundCounter
@onready var grenades_label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.enemies_active:
		round_counter.show()
	else:
		round_counter.hide()
	
func _physics_process(delta: float) -> void:
	ammo.text = "Ammo: " + str(Global.player.ammunition_remaining) + "/" + str(Global.player.max_ammunition)
	reserves.text = "Reserves: " + str(Global.player.reserves)
	health_bar.max_value = Global.player_max_health
	label.text = str(Global.player_health)
	health_bar.value = Global.player_health
	round_counter.text = "Round: " + str(Global.wins) + "/5"
	grenades_label.text = "Grenades: " + str(Global.player.grenades) + "/" + str(int(Global.player_max_grenades))
