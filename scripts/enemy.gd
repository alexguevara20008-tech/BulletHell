extends Area2D

var speed = randf_range(110.0, 190.0)
var hp = 3
var is_dead = false
var is_boss = false
var direction_x = 1
var bullet_scene = preload("res://bullet.tscn")

# 1. Cambia esta ruta por el nombre real de la imagen de tu Boss
var boss_texture = preload("res://assets/boss.png") 

func _ready():
	add_to_group("enemies")
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
		
	if is_boss:
		hp = 30
		speed = 160.0
		scale = Vector2(2.5, 2.5) # Si tu imagen del boss ya es grande, puedes cambiarlo a Vector2(1, 1)
		
		# 2. Cambiamos la textura del Sprite2D
		if has_node("Sprite2D"):
			$Sprite2D.texture = boss_texture

func _physics_process(delta):
	if is_boss:
		if position.y < 120:
			position.y += speed * delta
		else:
			position.x += speed * direction_x * delta
			if position.x > 460:
				direction_x = -1
			elif position.x < 80:
				direction_x = 1
	else:
		position.y += speed * delta

func take_damage(amount):
	if is_dead:
		return
		
	hp -= amount
	if hp <= 0:
		is_dead = true
		if get_parent().has_method("add_score"):
			if is_boss:
				get_parent().add_score(200)
			else:
				get_parent().add_score(10)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	if not is_boss:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("player_bullets"):
		take_damage(1)
		area.queue_free()

func _on_timer_timeout():
	var player = get_parent().get_node_or_null("Player")
	if player:
		var bullet = bullet_scene.instantiate()
		bullet.position = global_position
		bullet.direction = (player.global_position - global_position).normalized()
		bullet.speed = 450 if is_boss else 350
		bullet.remove_from_group("player_bullets")
		bullet.add_to_group("enemy_bullets")
		get_parent().add_child(bullet)
		bullet.rotation_degrees = 180
