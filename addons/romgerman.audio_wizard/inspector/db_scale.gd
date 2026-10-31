extends RefCounted

const FONT_SIZE := 12
const TICK_WIDTH := 6
const TICK_THICKNESS := 1.0
const MIN_DB := -80.0
const MAX_DB := 12.0
const TICK_MARKS := [-80, -60, -36, -24, -12, -6, 0, 6, 12, 24, 36, 60]

var owner_ctrl: Control

func _init(ctrl: Control) -> void:
	owner_ctrl = ctrl

func get_min_db() -> float:
	return MIN_DB

func get_max_db() -> float:
	return MAX_DB

## Returns width of the drawn scale
func draw(pos: Vector2, max_height: float, font: Font, color: Color = Color.GRAY) -> float:
	var tick_text_sizes := []
	
	for tick_db in TICK_MARKS:
		if tick_db > get_max_db() or tick_db < get_min_db():
			continue
		
		var tick_string := str(tick_db)
		var tick_string_size := font.get_string_size(
			tick_string,
			HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			FONT_SIZE,
			TextServer.JUSTIFICATION_NONE,
			TextServer.DIRECTION_LTR,
			TextServer.ORIENTATION_HORIZONTAL
		)
		tick_text_sizes.push_back(tick_string_size)
	
	var max_tick_text_size: Vector2 = tick_text_sizes.max()
	var x_offset := TICK_WIDTH + max_tick_text_size.x
	
	for tick_db in TICK_MARKS:
		if tick_db > get_max_db() or tick_db < get_min_db():
			continue
		
		var y := db_to_y(tick_db, max_height)
		
		owner_ctrl.draw_line(
			Vector2(pos.x - x_offset, y + pos.y),
			Vector2(pos.x - x_offset - TICK_WIDTH, y + pos.y),
			color,
			TICK_THICKNESS
		)
		
		owner_ctrl.draw_string(
			font,
			Vector2(
				pos.x - x_offset + TICK_WIDTH,
				y + FONT_SIZE * 0.5 - TICK_THICKNESS * 2.0 + pos.y
			),
			str(tick_db),
			HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			FONT_SIZE,
			color,
			TextServer.JUSTIFICATION_NONE
		)
	
	return x_offset + TICK_WIDTH * 1.5

func db_to_y(db: float, height: float) -> float:
	var t := (db - get_max_db()) / (get_min_db() - get_max_db())
	return t * height
