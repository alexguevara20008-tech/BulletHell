extends Node2D

var enemy_scene = preload("res://enemy.tscn")
var wave = 1

func _ready():
	spawn_wave()
	var timer = Timer.new()
	timer.wait_time = 4.0
	timer.autostart = true
	timer.timeout.connect(_on_wave_timer_timeout)
	add_child(timer)

func _on_wave_timer_timeout():
	wave += 1
	spawn_wave()

func spawn_wave():
	var count = min(2 + wave, 6)
	var spacing = 540.0 / (count + 1)
	
	for i in range(count):
		var enemy = enemy_scene.instantiate()
		enemy.position = Vector2(spacing * (i + 1), -40)
		add_child(enemy)
