extends PanelContainer
class_name Stats_Pane

@onready var dmg_lable: Label = %DMGLable
@onready var hp_lable: Label = %HPLable
@onready var vel_lable: Label = %VelLable
@onready var mana_lable: Label = %ManaLable
@onready var crit_lable: Label = %CritLable
@onready var crit_dmg_lable: Label = %CritDMGLable

@onready var curr_points_lable: Label = %CurrPointsLable
@onready var curr_level_lable: Label = %CurrLevelLable

@onready var str_points_lable: Label = %STRPointsLable
@onready var dex_points_lable: Label = %DEXPointsLable
@onready var int_points_lable: Label = %INTPointsLable

func _ready() -> void:
	EventBus.on_player_created.connect(_on_player_created)
	EventBus.on_player_stats_updated.connect(_on_player_stats_updated)


func update_stats() -> void:
	if not is_instance_valid(Refs.player):
		return
	dmg_lable.text = "DMG: %s" % str(Refs.player.damage)
	hp_lable.text = "HP: %s" % str(Refs.player.max_health)
	vel_lable.text = "VEL: %s" % str(Refs.player.move_speed)
	mana_lable.text = "Mana: %s" % str(Refs.player.max_mana)
	crit_lable.text = "CRIT: %s" % str(Refs.player.crit_chance)
	
	curr_level_lable.text = "Level: %s" % str(Refs.player.curr_level)
	curr_points_lable.text = "Points: %s" % str(Refs.player.curr_points)
	
	str_points_lable.text = str(Refs.player.strength_value)
	dex_points_lable.text = str(Refs.player.dexterity_value)
	int_points_lable.text = str(Refs.player.intelligence_value)


func _on_str_button_pressed() -> void:
	Refs.player.upgrade_stat("STR")


func _on_dex_button_pressed() -> void:
	Refs.player.upgrade_stat("DEX")


func _on_int_button_pressed() -> void:
	Refs.player.upgrade_stat("INT")

func _on_player_created() -> void:
	update_stats()


func _on_player_stats_updated() -> void:
	update_stats()
