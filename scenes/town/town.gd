extends Node2D
class_name Town

@export var Player_scene: PackedScene

func _ready() -> void:
	create_player()


func create_player() -> void:
	var player: Player = Player_scene.instantiate()
	add_child(player)
	player.setup()
	EventBus.on_player_created.emit()
