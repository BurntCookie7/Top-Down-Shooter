extends Control
@onready var control_settings: Control = $Panel/VBoxContainer/ControlSettings
@onready var control_mode: Label = $Panel/VBoxContainer/ControlSettings/ControlMode
@onready var control_mode_selection: OptionButton = $Panel/VBoxContainer/ControlSettings/ControlMode/OptionButton
@onready var mouse_turn_controls: Control = $Panel/VBoxContainer/ControlSettings/MouseTurn
@onready var key_turn_controls: Control = $Panel/VBoxContainer/ControlSettings/KeyTurn

var controls_to_show = 0
var current_tab

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	manage_tabs(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tab_bar_tab_changed(tab: int) -> void:
	manage_tabs(tab)

func hide_all():
	control_settings.hide()
	mouse_turn_controls.hide()
	key_turn_controls.hide()


func manage_tabs(tab):
	current_tab = tab
	match tab:
		0:
			hide_all()
		1:
			hide_all()
		2:
			hide_all()
			control_settings.show()
			match controls_to_show:
				0:
					mouse_turn_controls.show()
					key_turn_controls.hide()
				1:
					mouse_turn_controls.hide()
					key_turn_controls.show()
			


func _on_option_button_item_selected(index: int) -> void:
	var option: String = control_mode_selection.get_item_text(index)
	option = option.replace(" ", "_")
	Global.player_control_mode = option
	controls_to_show = index
	manage_tabs(current_tab)


func _on_exit_pressed() -> void:
	queue_free()
