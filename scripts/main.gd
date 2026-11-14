extends Node2D

var enemy_scene = preload("res://enemy.tscn")
var music = preload("res://assets/musica.mp3")
var wave = 1

var score = 0
var score_label: Label
var boss_spawned = false # Controla que el boss salga una sola vez

func _ready():
	var ui = CanvasLayer.new()
	add_child(ui)
	
	score_label = Label.new()
	score_label.text = "Puntos: 0"
	score_label.position = Vector2(20, 20)
	score_label.add_theme_font_size_override("font_size", 24)
	ui.add_child(score_label)

	var music_player = AudioStreamPlayer.new()
	music_player.stream = music
	add_child(music_player)
	music_player.play()

	spawn_wave()
	var timer = Timer.new()
	timer.wait_time = 4.0
	timer.autostart = true
	timer.timeout.connect(_on_wave_timer_timeout)
	add_child(timer)

func add_score(points):
	score += points
	score_label.text = "Puntos: " + str(score)
	
	# Si llega a 500 puntos y el boss no ha salido, lo creamos
	if score >= 100 and not boss_spawned:
		boss_spawned = true
		spawn_boss()

func spawn_boss():
	var boss = enemy_scene.instantiate()
	boss.is_boss = true # Activamos el modo boss antes de añadirlo a la escena
	boss.position = Vector2(270, -80) # Aparece centrado arriba
	add_child(boss)

func _on_wave_timer_timeout():
	wave += 1
	spawn_wave()

func spawn_wave():
	var count = min(2 + wave, 8)
	
	for i in range(count):
		var enemy = enemy_scene.instantiate()
		var random_x = randf_range(40.0, 500.0)
		var random_y = randf_range(-250.0, -40.0)
		enemy.position = Vector2(random_x, random_y)
		add_child(enemy)
