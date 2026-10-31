@tool
extends "../effect_editor_base.gd"

const RESOLUTION := 128
const OCTAVES := 2
const MARK_LENGTH := 12.0
const SEMI_MIN := 12.0 * (log(0.01) / log(2.0))
const SEMI_MAX := 12.0 * (log(16.0) / log(2.0))

#func _process(delta: float) -> void:
	#if eff_handle.has_effect():
		#queue_redraw()
		#pass

func _draw() -> void:
	if eff_handle.has_effect():
		draw_layout()
		draw_representation()

func draw_representation() -> void:
	var content_rect := get_rect().grow(-CONTENT_PADDING)
	
	var eff_pitch := eff_handle.get_effect() as AudioEffectPitchShift
	var pitch_scale := eff_pitch.pitch_scale
	
	var semi := 12.0 * (log(pitch_scale) / log(2.0))
	var semi_octaves := ceili(abs(semi) / 12.0)
	var octaves := maxi(semi_octaves, OCTAVES)
	
	var semi_text := "%0.02f st" % semi
	
	draw_string(
		get_theme_default_font(),
		Vector2(CONTENT_PADDING, content_rect.size.y * 0.85),
		semi_text,
		HORIZONTAL_ALIGNMENT_CENTER,
		content_rect.size.x,
		32,
		accent_color
	)
	
	var radius := content_rect.size.y - MARK_LENGTH * 0.5
	var angle := remap(semi, -octaves * 12.0, octaves * 12.0, -PI, 0.0)

	draw_arc(
		content_rect.get_center() + Vector2(0.0, content_rect.get_center().y - CONTENT_PADDING),
		radius,
		-PI * 0.5,
		angle,
		RESOLUTION,
		Color(ThemeUtils.modify_color(accent_color, 0.7), 0.5),
		MARK_LENGTH,
		true
	)
	
	var center := Vector2(content_rect.get_center().x, content_rect.size.y + CONTENT_PADDING)
	var center_line_dir := Vector2(cos(angle), sin(angle))
	radius += MARK_LENGTH * 0.5
	draw_line(
		center + center_line_dir * (radius - MARK_LENGTH),
		center + center_line_dir * radius,
		accent_color,
		line_thickness_primary,
		true
	)

func draw_layout() -> void:
	var rect := get_rect()
	
	# Background
	draw_rect(rect, base_color, true)
	
	var eff_pitch := eff_handle.get_effect() as AudioEffectPitchShift
	var pitch_scale := eff_pitch.pitch_scale
	
	var semi := 12.0 * (log(pitch_scale) / log(2.0))
	var semi_octaves := ceili(abs(semi) / 12.0)
	var octaves := maxi(semi_octaves, OCTAVES)
	
	var content_rect := get_rect().grow(-CONTENT_PADDING)
	var pivot := Vector2(content_rect.get_center().x, content_rect.size.y + CONTENT_PADDING)
	var radius := content_rect.size.y
	
	for i in range(-octaves, octaves + 1):
		var t := i / (octaves * 2.0)
		var angle := PI * t - PI * 0.5
		
		var x := cos(angle)
		var y := sin(angle)
		
		var line_start := pivot + Vector2(x, y) * (radius - MARK_LENGTH)
		var line_end := pivot + Vector2(x, y) * (radius)
		
		draw_line(
			line_start,
			line_end,
			ThemeUtils.modify_color(base_color, 0.3),
			line_thickness_secondary,
			true
		)
		
		var mark_text := "%soct" % i
		var text_size := get_theme_default_font().get_string_size(
			mark_text,
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			ThemeUtils.FONT_SIZE
		)
		
		draw_string(
			get_theme_default_font(),
			line_start - Vector2(text_size.x * 0.5, -text_size.y * 0.25) - Vector2(x, y) * text_size,
			mark_text,
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			ThemeUtils.FONT_SIZE,
			ThemeUtils.modify_color(base_color, 0.3)
		)
		
		if i != octaves:
			for j in range(1, 12):
				t = j / 12.0
				var angle_j = angle + (PI / (octaves * 2.0)) * t
				
				x = cos(angle_j)
				y = sin(angle_j)
				
				line_start = pivot + Vector2(x, y) * (radius - MARK_LENGTH * 0.5)
				line_end = pivot + Vector2(x, y) * (radius)
				
				draw_line(
					line_start,
					line_end,
					ThemeUtils.modify_color(base_color, 0.2),
					line_thickness_thin,
					true
				)
