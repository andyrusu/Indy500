extends Control

@onready var menuNode : Control = $CenterContainer/Menu
@onready var optionsNode : Control = $CenterContainer/Options
@onready var creditsNode : Control = $CenterContainer/Credits

# Called when the node enters the scene tree for the first time.
func _ready():
	show_menu()

func show_menu():
	menuNode.visible = true
	optionsNode.visible = false
	creditsNode.visible = false

func _on_start_game_pressed():
	get_tree().call_group('MainController', 'start_game')


func _on_options_pressed():
	menuNode.visible = false
	optionsNode.visible = true

func _on_credits_pressed():
	menuNode.visible = false
	creditsNode.visible = true

func _on_back_pressed():
	show_menu()

func _on_exit_pressed():
	get_tree().quit() # Replace with function body.
