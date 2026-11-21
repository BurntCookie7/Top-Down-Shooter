extends StaticBody2D
@onready var area_2d: Area2D = $Area2D
@onready var sitting_pos: Node2D = $SittingPos

@export var Upgrades_Menu: PackedScene
@export var hit_color: Color


var menu_made: bool
var menu = null
var buffer_node: Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.can_sit = true
		SignalBus.player_entered_bench.emit(self, sitting_pos.global_position)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.can_sit = false

func load_upgrades():
	if menu_made:
		menu.show()
		menu.global_rotation = Global.playe.camera.global_rotation - deg_to_rad(90)
		menu.global_position = Global.playe.global_position
		menu.global_position.y -= 100
		#print("menu shown")
	else:
		menu = Upgrades_Menu.instantiate()
		menu.name = "Shop"
		Global.canvas_layer.add_child(menu)
		#menu.global_rotation = Global.playe.camera.global_rotation - deg_to_rad(90)
		#menu.global_position = Global.playe.global_position
		#menu.global_position.y -= 100
		#for upgrade in Global.upgrades:
			#create_button()
		#for child in menu.get_children():
			#child.z_index = 500
		buffer_node = Control.new()
		menu_made = true
		
		#print("menu shown")
	

func unload_upgrades():
	menu.hide()
	
func remove_upgrades():
	menu.queue_free()
