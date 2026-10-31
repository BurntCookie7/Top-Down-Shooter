@tool
extends Control

const EffectHandle := preload("res://addons/romgerman.audio_wizard/effect_handle.gd")
const ThemeUtils := preload("res://addons/romgerman.audio_wizard/theme_utils.gd")

const CONTENT_PADDING := 12.0

var eff_handle: EffectHandle = EffectHandle.new()

var base_color: Color
var accent_color: Color
var text_color: Color
var is_light_theme: bool
var line_thickness_primary: float
var line_thickness_secondary: float
var line_thickness_thin: float

func _get_theme_colors() -> void:
	base_color = ThemeUtils.get_base_color(self)
	accent_color = ThemeUtils.get_accent_color(self)
	is_light_theme = ThemeUtils.is_light_color(base_color)
	text_color = Color.BLACK if is_light_theme else Color.WHITE
	line_thickness_primary = ThemeUtils.get_line_thickness(2)
	line_thickness_secondary = ThemeUtils.get_line_thickness(1)
	line_thickness_thin = ThemeUtils.get_line_thickness(0)

func queue_redraw_arg1(_arg1: Variant) -> void:
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		_get_theme_colors()
		if eff_handle.has_effect():
			# This one is needed to make it redraw when it's open in a sub-inspector
			# EditorInspector.property_edited doesn't support nested resources
			EditorInterface.get_editor_undo_redo().history_changed.connect(queue_redraw)
			# This one is the main one. The previous one maybe is enough though
			EditorInterface.get_inspector().property_edited.connect(queue_redraw_arg1)
	elif what == NOTIFICATION_EXIT_TREE:
		if eff_handle.has_effect():
			EditorInterface.get_editor_undo_redo().history_changed.disconnect(queue_redraw)
			EditorInterface.get_inspector().property_edited.disconnect(queue_redraw_arg1)
	elif what == NOTIFICATION_THEME_CHANGED:
		_get_theme_colors()
		queue_redraw()
