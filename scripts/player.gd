extends CharacterBody2D

var speed = 600
var hp = 30
var bullet_scene = preload("res://bullet.tscn")

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	bullet.add_to_group("player_bullets") # Asegura que el enemigo detecte la bala
	get_parent().add_child(bullet)

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		if get_parent().has_method("game_over"):
			get_parent().game_over()
		queue_free()

func _on_hitbox_area_entered(area):
	if area.is_in_group("enemy_bullets"):
		take_damage(1)
		area.queue_free()
	elif area.is_in_group("enemies"):
		take_damage(5)
		area.queue_free()
