extends CharacterBody2D
class_name Player

@export_group("状态")
@export var max_health: float = 10.0
@export var max_mana: float = 10.0
@export var move_speed: float = 60.0
@export var damage: float = 5.0
@export var crit_chance: float = 0.0
@export var crit_damage: float = 0.0

@export_group("经验")
@export var base_exp: float = 100.0
@export var exp_multiplier: float = 2.0

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var fsm: FSM = $FSM
@onready var health_component: HealthComponent = $HealthComponent
@onready var enemy_area: Area2D = %EnemyAttackArea
@onready var weapon: Node2D = $Weapon



@onready var attack_position: Dictionary = {
	"down" : %Down,
	"left" : %Left,
	"up" : %Up,
	"right" : %Right
}

var curr_exp: float
var next_level_exp: float

var curr_level: int = 1
var curr_points: int = 0

var curr_mana: float
var last_direction: String =  "down"


func _ready() -> void:
	setup()


func _process(delta: float) -> void:
	if fsm.curr_state != null:
		fsm.curr_state.process_state(delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		add_exp(20)


func is_moving() -> bool:
	var move_input = ["move_down", "move_up", "move_left", "move_right"]
	for input in move_input:
		if Input.is_action_pressed(input):
			return true
	return false


func update_direction(input_vector: Vector2) -> void:
	if input_vector == Vector2.ZERO:
		return
	
	if abs(input_vector.x) > abs(input_vector.y):
		last_direction = "right" if input_vector.x > 0 else "left"
	else:
		last_direction = "down" if input_vector.y > 0 else "up"

func play_direction_anim(anim_name: String) -> void:
	anim_sprite.play("%s_%s" % [anim_name, last_direction])


func add_exp(value: float) -> void:
	curr_exp += value
	while curr_exp >= next_level_exp:
		level_up()
	
	EventBus.on_player_new_level.emit(curr_exp, next_level_exp)


func level_up() -> void:
	curr_exp -= next_level_exp
	curr_level += 1
	curr_points += 4
	next_level_exp *= exp_multiplier
	
	EventBus.on_player_stats_updated.emit()


func setup() -> void:

	reset_health()
	reset_mana()
	next_level_exp = base_exp


func reset_health() -> void:
	health_component.setup(max_health)
	EventBus.on_player_health_updated.emit(max_health, max_health)


func reset_mana() -> void:
	curr_mana = max_mana
	EventBus.on_player_mana_updated.emit(max_mana, max_mana)


func use_mana(value: float) -> void:
	curr_mana = max(curr_mana - value, 0)
	EventBus.on_player_mana_updated.emit(curr_mana, max_mana)


func enable_weapon_collision(value: bool) -> void:
	enemy_area.monitoring = value
