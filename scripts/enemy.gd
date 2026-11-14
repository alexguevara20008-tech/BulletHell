extends Area2D

var speed = 150
var hp = 3

func _physics_process(delta):
	position.y += speed * delta

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("player_bullets"):
		take_damage(1)
		area.queue_free()
