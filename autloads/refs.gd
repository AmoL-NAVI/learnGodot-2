extends Node

var player: Player
var hud: HUD

const DAMAGE_FX_SCENE = preload("uid://dm60h120xx5co")
const DAMAGE_TEXT_SCENE  = preload("uid://cctspykeusbfc")
const NEW_LEVEL_FX_SCENE  = preload("uid://cqvksi2bfrpnv")
const DROP_ITEM_SCENE = preload("uid://bwuru5w8fxlnk")



func create_damage_fx(pos: Vector2) -> void:
	create_fx_at_pos(DAMAGE_FX_SCENE, pos)

func create_new_level_fx(pos: Vector2) -> void:
	create_fx_at_pos(NEW_LEVEL_FX_SCENE, pos)

func create_damage_text(pos: Vector2, amount: float) -> void:
	var lable: Label = DAMAGE_TEXT_SCENE.instantiate()
	lable.text = str(amount)
	lable.global_position = pos + Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	get_tree().root.add_child(lable)
	
	var tween = create_tween()
	tween.tween_property(lable, "global_position:y", lable.global_position.y - 24.0, 0.7)
	tween.tween_callback(lable.queue_free)

func create_fx_at_pos(scene: PackedScene, pos: Vector2) -> void:
	var fx: AnimatedSprite2D = scene.instantiate()
	fx.global_position = pos
	get_tree().root.add_child(fx)
	fx.animation_finished.connect(func(): fx.queue_free())
	
