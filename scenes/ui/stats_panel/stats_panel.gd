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


func _on_str_button_pressed() -> void:
	pass # Replace with function body.


func _on_dex_button_pressed() -> void:
	pass # Replace with function body.


func _on_int_button_pressed() -> void:
	pass # Replace with function body.
