extends Control
@onready var ammo: Label = $Ammo
@onready var reserves: Label = $Reserves 
@onready var health_bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label
@onready var round_counter: Label = $RoundCounter

@onready var player = Global.player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var hp: int = clampi(Global.player_health, 0, Global.player_max_health)
	ammo.text = "Ammo: " + str(player.ammunition_remaining) + "/" + str(player.max_ammunition)
	reserves.text = "Reserves: " + str(player.reserves)
	health_bar.max_value = Global.player_max_health
	health_bar.value = hp
	label.text = str(hp)
	round_counter.text = "Round: " + str(Global.wins) + "/5"
