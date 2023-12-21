extends Node2D

func start_game():
	var mainMenu : Control = $MainMenu
	mainMenu.queue_free()
	var levelScene = preload("res://Scenes/Levels/Level1.tscn").instantiate()
	add_child(levelScene)
