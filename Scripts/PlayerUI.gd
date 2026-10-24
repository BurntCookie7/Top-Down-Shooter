extends Control
@onready var ammo: Label = $Ammo
@onready var reserves: Label = $Reserves 

@export var player: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	ammo.text = "Ammo: " + str(player.ammunition_remaining) + "/" + str(player.total_ammunition)
	reserves.text = "Reserves: " + str(player.reserves)
