extends Area2D

var speed = 700
var direction = Vector2.UP

func _physics_process(delta):
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
