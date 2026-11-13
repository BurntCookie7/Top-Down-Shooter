extends Control
@onready var control_settings: Control = $Panel/VBoxContainer/ControlSettings
@onready var control_mode: Label = $Panel/VBoxContainer/ControlSettings/ControlMode
@onready var control_mode_selection: OptionButton = $Panel/VBoxContainer/ControlSettings/ControlMode/OptionButton
@onready var mouse_turn_controls: Control = $Panel/VBoxContainer/ControlSettings/MouseTurn
@onready var key_turn_controls: Control = $Panel/VBoxContainer/ControlSettings/KeyTurn
@onready var general_settings: Control = $Panel/VBoxContainer/GeneralSettings
@onready var check_box: CheckBox = $Panel/VBoxContainer/GeneralSettings/Arachnophobia/CheckBox
@onready var h_slider: HSlider = $Panel/VBoxContainer/ControlSettings/Label/HSlider

var controls_to_show = 0
var current_tab

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	h_slider.value = Global.turn_sensitivity
	check_box.set_pressed_no_signal(Global.arachnophobia)
	manage_tabs(0)
	match Global.player.control_mode:
		Global.player.Control_Mode.Mouse_Turn:
			controls_to_show = 0
			control_mode_selection.selected = 0
		Global.player.Control_Mode.Key_Turn:
			controls_to_show = 1
			control_mode_selection.selected = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tab_bar_tab_changed(tab: int) -> void:
	manage_tabs(tab)

func hide_all():
	control_settings.hide()
	mouse_turn_controls.hide()
	key_turn_controls.hide()
	general_settings.hide()


func manage_tabs(tab):
	current_tab = tab
	match tab:
		0:
			hide_all()
			general_settings.show()
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


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.arachnophobia = true
	else:
		Global.arachnophobia = false
	print(Global.arachnophobia)


func _on_h_slider_value_changed(value: float) -> void:
	Global.turn_sensitivity = value
