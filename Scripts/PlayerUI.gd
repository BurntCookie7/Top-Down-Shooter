extends Control
@onready var ammo: Label = $Ammo
@onready var reserves: Label = $Reserves 
@onready var health_bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label

@export var player: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	ammo.text = "Ammo: " + str(player.ammunition_remaining) + "/" + str(player.max_ammunition)
	reserves.text = "Reserves: " + str(player.reserves)
	health_bar.max_value = Global.player_max_health
	health_bar.value = Global.player_health
	label.text = str(Global.player_health)
