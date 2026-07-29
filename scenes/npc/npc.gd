extends Area2D
class_name NPC

enum NPCType {
	IDLE,
	SHOP,
	QUEST,
	CRAFTING
}

@export var type: NPCType
@export var dialogue: DialogueData

@export_group("Movement")
@export var can_move: bool
@export var move_speed: float = 30.0
@export var wait_time: float = 3.0

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var nav_agent: NavigationAgent2D = $NavAgent


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if dialogue:
			EventBus.on_dialogue_started.emit(dialogue)
