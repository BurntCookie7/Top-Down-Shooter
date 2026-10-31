@tool
extends "../effect_editor_base.gd"

const SOURCE_SIZE := 6.0

#func _process(delta: float) -> void:
	#if eff_handle.has_effect():
		#queue_redraw()
		#pass

func _draw() -> void:
	draw_layout()
	if eff_handle.has_effect():
		draw_representation()

func draw_representation() -> void:
	var content_rect := get_rect().grow(-CONTENT_PADDING)
	var min_radius := content_rect.size.y * 0.1
	var max_radius := content_rect.size.y * 0.5
	
	var eff_reverb := eff_handle.get_effect() as AudioEffectReverb
	var room_radius := remap(eff_reverb.room_size, 0.0, 1.0, min_radius, max_radius)
	var hi_pass := eff_reverb.hipass
	var damping := eff_reverb.damping
	var spread := eff_reverb.spread
	
	var width := content_rect.size.x
	var height := content_rect.size.y
	const COUNT := 16.0
	const CENTER_WIDTH := 1.0
	for i in range(0, COUNT):
		var t := float(i) / (COUNT - 1.0)
		var strength := absf(cos(t * PI))
		var d := (t - 0.5) / 2.0
		var side := -1 if d < 0 else 1
		var center_offset := side * (room_radius * CENTER_WIDTH)
		var x := content_rect.position.x + width * t + center_offset - center_offset * strength
		draw_line(
			Vector2(x, content_rect.position.y),
			Vector2(x, content_rect.position.y + height),
			Color(accent_color, strength * strength * spread),
			line_thickness_secondary,
			false
		)
	
	# Whatever dude. How do you even transform in 2D?
	const SCALE := 0.7
	const SIZE := 0.8
	const MOVE := 0.15
	draw_set_transform_matrix(Transform2D.IDENTITY.translated(Vector2(0.0, content_rect.get_center().y * (SCALE + MOVE))).scaled(Vector2(1.0, SCALE)))
	var move_y := content_rect.get_center().y * SIZE
	#draw_circle(content_rect.get_center(), room_radius, Color(accent_color, 0.1), true, -1.0, true)
	
	# Center point
	draw_circle(content_rect.get_center() + Vector2(0, -move_y * 0.5), SOURCE_SIZE, accent_color, true, -1.0, true)
	
	# Draw the top circle to stop the jitter
	draw_circle(
		content_rect.get_center() + Vector2(0, -move_y),
		room_radius,
		accent_color,
		false,
		line_thickness_primary,
		true
	)
	var depth := 4.0 + 28.0 * damping
	for i in range(0, depth):
		var t := float(i) / (depth - 1.0)
		draw_circle(
			content_rect.get_center() + Vector2(0, -move_y * t),
			room_radius,
			Color(accent_color, 0.1 + (t * 0.9) * (1.0 - hi_pass)),
			false,
			line_thickness_primary,
			true
		)

func draw_layout() -> void:
	var rect := get_rect()
	
	# Background
	draw_rect(rect, base_color, true)
