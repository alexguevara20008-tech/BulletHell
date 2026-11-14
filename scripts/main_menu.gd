extends Control

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_creditos_pressed() -> void:
	$CreditsPanel.visible = true

func _on_salir_pressed() -> void:
	$CreditsPanel.visible = false
