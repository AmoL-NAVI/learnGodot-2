extends PanelContainer
class_name Equipment_Panel

@onready var slots: Array[EquipmentSlot] = [
	%HelmetSlot, 
	%WeaponSlot,
	%BodySlot, 
	%LegsSlot, 
	%RingSlot
]

func _ready() -> void:
	Inventory.on_equipment_change.connect(_on_equipment_change)
	for slot: EquipmentSlot in slots:
		slot.pressed.connect(_on_slot_pressed.bind(slot))


func _on_equipment_change() -> void:
	var items: Array[EquipData] = GameData.equipment.values()
	for i in slots.size():
		slots[i].load_data(items[i])
		


func _on_slot_pressed(slot: EquipmentSlot) -> void:
	Inventory.unequipa_item(slot.equip_type)
