extends CanvasLayer
class_name HUD

@onready var equipment_panel: Equipment_Panel = %EquipmentPanel
@onready var inventory_panel: InventoryPanel = %InventoryPanel
@onready var stats_panel: Stats_Pane = %StatsPanel
@onready var skills_panel: SkillPanel = %SkillsPanel

@onready var health_bar: ProgressBar = $HealthBar
@onready var mana_bar: ProgressBar = $ManaBar
@onready var exp_bar: ProgressBar = $ExpBar

@onready var health_lable: Label = %HealthLable
@onready var mana_lable: Label = %ManaLable

func _ready() -> void:
	EventBus.on_player_health_updated.connect(_on_player_health_updated)
	EventBus.on_player_mana_updated.connect(_on_player_mana_updated)
	EventBus.on_player_new_level.connect(_on_player_new_level)
	disable_all_button_focus(self)


func disable_all_button_focus(node: Node) -> void:
	if node is Button:
		node.focus_mode = Control.FOCUS_NONE
	for child in node.get_children():
		disable_all_button_focus(child)

func _on_equipment_button_pressed() -> void:
	equipment_panel.visible = not equipment_panel.visible


func _on_inventory_button_pressed() -> void:
	inventory_panel.visible = not inventory_panel.visible


func _on_stats_button_pressed() -> void:
	stats_panel.visible = not stats_panel.visible


func _on_skills_button_pressed() -> void:
	skills_panel.visible = not skills_panel.visible


func _on_player_health_updated(curr: float, max: float) -> void:
	health_bar.value = curr / max
	health_lable.text = "%s / %s" % [curr, max]


func _on_player_mana_updated(curr: float, max: float) -> void:
	mana_bar.value = curr / max
	mana_lable.text = "%s / %s" % [curr, max]


func _on_player_new_level(curr: float, new_level: float) -> void:
	exp_bar.value = curr / new_level
