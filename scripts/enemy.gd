extends Area2D

var speed = 150
var hp = 3
var is_dead = false # Evita que sume puntos dos veces por error
var bullet_scene = preload("res://bullet.tscn")

func _ready():
	add_to_group("enemies") # Para que el jugador detecte el choque con el enemigo
	# Conecta la señal por código si no está conectada en el editor
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

func _physics_process(delta):
	position.y += speed * delta

func take_damage(amount):
	if is_dead:
		return
		
	hp -= amount
	if hp <= 0:
		is_dead = true
		if get_parent().has_method("add_score"):
			get_parent().add_score(10)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
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
		bullet.speed = 350
		bullet.remove_from_group("player_bullets")
		bullet.add_to_group("enemy_bullets")
		get_parent().add_child(bullet)
		bullet.rotation_degrees = 180
