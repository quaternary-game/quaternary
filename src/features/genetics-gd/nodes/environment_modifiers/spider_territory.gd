extends Area2D

var color : Color = Control.new().get_theme_color("10", "pallete")

func _draw() -> void:
	for i in range(5):
		var step : float = i * $CollisionShape2D.shape.radius/5 
		draw_arc(Vector2.ZERO, $CollisionShape2D.shape.radius-step, 0, 2 * PI, 100, color, -1, true)
	for i in range(10):
		var step : float = i * 2 * PI / 10
		var radius : float = $CollisionShape2D.shape.radius
		var point : Vector2 = Vector2(sin(step )*radius, cos(step)*radius)
		draw_line(Vector2.ZERO, point, color, -1, true)
