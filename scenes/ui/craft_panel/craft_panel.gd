extends Control
class_name CraftPanel

@export var recipes: Array[CraftData]

@onready var container: GridContainer = %Container
@onready var materials_container: VBoxContainer = %MaterialsContainer

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_name: Label = %ItemName

@onready var material_1_icon: TextureRect = %Material1Icon
@onready var material_1_name: Label = %Material1Name
@onready var material_1_quality: Label = %Material1Quality

@onready var material_2_icon: TextureRect = %Material2Icon
@onready var material_2_name: Label = %Material2Name
@onready var material_2_quality: Label = %Material2Quality

@onready var amount_lable: Label = %AmountLable

var amount_selected: int = 1
var button_selected: CraftButton


func _ready() -> void:
	materials_container.hide()
	for button in container.get_children():
		button.queue_free()
	create_craft_recipes()


func create_craft_recipes() -> void:
	for data: CraftData in recipes:
		var button: CraftButton = Refs.CRAFT_BUTTON_SCENE.instantiate()
		button.pressed.connect(_on_button_pressed.bind(button))
		container.add_child(button)
		button.load_data(data)


func update_material_information() -> void:
	item_icon.texture = button_selected.data.craft_item.icon
	item_name.text = button_selected.data.craft_item.name
	amount_lable.text = str(amount_selected)
	
	var material_1 = button_selected.data.craft_materials[0]
	material_1_icon.texture = material_1.item.icon
	material_1_name.text = material_1.item.name
	var require_1: int = material_1.amount * amount_selected
	material_1_quality.text = "%s/%s" % [require_1, Inventory.count_item(material_1.item)]
	
	var material_2 = button_selected.data.craft_materials[1]
	material_2_icon.texture = material_2.item.icon
	material_2_name.text = material_2.item.name
	var require_2: int = material_2.amount * amount_selected
	material_2_quality.text = "%s/%s" % [require_2, Inventory.count_item(material_2.item)]


func can_craft_item() -> bool:
	var material_1 = button_selected.data.craft_materials[0]
	var material_2 = button_selected.data.craft_materials[1]
	
	var require_1: int = material_1.amount * amount_selected
	var require_2: int = material_2.amount * amount_selected
	
	return Inventory.count_item(material_1.item) >= require_1 and Inventory.count_item(material_2.item) >= require_2
	
	


func _on_button_pressed(craft_button: CraftButton) -> void:
	if not materials_container.visible:
		materials_container.show()
		
	button_selected = craft_button
	amount_selected = 1
	update_material_information()


func _on_close_button_pressed() -> void:
	hide()
	materials_container.hide()


func _on_remove_button_pressed() -> void:
	amount_selected -= 1
	amount_selected = max(1, amount_selected)
	update_material_information()


func _on_add_button_pressed() -> void:
	amount_selected += 1
	update_material_information()


func _on_craft_button_pressed() -> void:
	if can_craft_item():
		var material_1 = button_selected.data.craft_materials[0]
		var material_2 = button_selected.data.craft_materials[1]
		
		Inventory.remove_item(material_1.item, material_1.amount * amount_selected)
		Inventory.remove_item(material_2.item, material_2.amount * amount_selected)
		Inventory.add_item(button_selected.data.craft_item, amount_selected)
		update_material_information()
