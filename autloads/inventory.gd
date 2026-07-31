extends Node

signal on_inventory_change
signal on_equipment_change

const INVENTORY_SIZE: int = 30

var inventory: Array[SlotData]


func _ready() -> void:
	inventory.clear()
	inventory.resize(INVENTORY_SIZE)

#region Find
# 返回仓库中所有空白槽位对应的索引数值
func get_empty_slot_index() -> Array[int]:
	var empty: Array[int] = []
	for i in inventory.size():
		if inventory[i] == null:
			empty.append(i)
	return empty

# 找到所有对应道具所在的槽位的索引数值
# 如果with_space为true则只返回有空位的格子，为false则无条件返回
func find_item_indexes(item: ItemData, with_space: bool = false) -> Array[int]:
	var found: Array[int] = []
	for i in inventory.size():
		var slot = inventory[i]
		if slot and slot.item == item:
			if with_space:
				if slot.quantity < item.max_stack:
					found.append(i)
			else:
				found.append(i)
	return found


func get_slot(index: int) -> SlotData:
	if index >= 0 and index < inventory.size():
		return inventory[index]
	return null


func get_slot_item(index: int) -> ItemData:
	var slot = get_slot(index)
	if slot:
		return slot.item
	return null


func count_item(item: ItemData) -> int:
	var total: int = 0
	for slot in inventory:
		if slot and slot.item == item:
			total += slot.quantity
	return total
#endregion


#region Add / Move
func add_item(item: ItemData, amount: int = 1) -> void:
	if not item:
		return
	
	var remaining = amount
	
	# 1.将道具堆叠到同类还有剩余容量的槽位中
	if item.max_stack > 1:
		for index in find_item_indexes(item, true):
			if remaining <= 0:
				break
			
			var slot = inventory[index]
			var space = item.max_stack - slot.quantity
			var to_give = min(space, remaining)
			
			slot.quantity += to_give
			remaining -= to_give
	
	# 2.使用空白槽位存放堆叠中多余的道具
	if remaining > 0:
		for index in get_empty_slot_index():
			if remaining <= 0:
				break
			
			var to_give = min(item.max_stack, remaining)
			inventory[index] = SlotData.new(item, to_give)
			remaining -= to_give
	
	var added = amount - remaining
	if added > 0:
		on_inventory_change.emit()


func remove_item(remove_item: ItemData, amount: int) -> void:
	var remaining = amount
	
	var slots = find_item_indexes(remove_item)
	slots.reverse()
	for index in slots:
		if remaining <= 0:
			break
		
		var slot: SlotData = inventory[index]
		var take = min(slot.quantity, remaining)
		slot.quantity -= take
		remaining -= take
		
		if slot.quantity <= 0:
			inventory[index] = null
	
	var removed = amount - remaining
	if removed > 0:
		on_inventory_change.emit()
#endregion


#region Equip
func equip_item(slot_index: int) -> void:
	var slot: SlotData = get_slot(slot_index)
	if not slot:
		return
	
	if not slot.item is EquipData:
		return
	
	var equip: EquipData = slot.item
	var equip_key: String =  equip.get_equip_key()
	
	var curr_equipment_item = GameData.equipment[equip_key]
	
	GameData.equipment[equip_key] = equip
	inventory[slot_index] = null
	
	if curr_equipment_item != null:
		add_item(curr_equipment_item, 1)
	
	on_inventory_change.emit()
	on_equipment_change.emit()


func unequipa_item(equip_type: EquipData.EquipType) -> void:
	var equip_key = GameData.equipment.keys()[equip_type]
	var equip_item = GameData.equipment[equip_key]
	
	if not equip_item:
		return
	
	add_item(equip_item, 1)
	GameData.equipment[equip_key] = null
	
	on_equipment_change.emit()
#endregion


#region Use Item
func use_item(slot_index: int) -> void:
	var slot: SlotData = inventory[slot_index]
	if not slot:
		return
	if not slot.item.is_consumable:
		return
	
	slot.quantity -= 1
	if slot.quantity <= 0:
		inventory[slot_index] = null
	
	on_inventory_change.emit()


func can_use_item(slot_index: int) -> bool:
	var slot: SlotData = get_slot(slot_index)
	return slot and slot.item.is_consumable
#endregion


#region Move Slots
func swap_slots(from_index: int, to_index: int) -> void:
	if from_index < 0 or from_index >= inventory.size():
		return
	if to_index < 0 or to_index >= inventory.size():
		return
	var temp = inventory[from_index]
	inventory[from_index] = inventory[to_index]
	inventory[to_index] = temp
	on_inventory_change.emit()


func merge_slots(from_index: int, to_index: int) -> void:
	var from_slot: SlotData = get_slot(from_index)
	var to_slot: SlotData = get_slot(to_index)
	
	if not from_slot or not to_slot:
		return
	if from_slot.item != to_slot.item:
		return
	
	var item = from_slot.item
	if item.max_stack <= 1:
		return
	
	var space = item.max_stack - to_slot.quantity
	var to_move = min(space, from_slot.quantity)
	
	to_slot.quantity += to_move
	from_slot.quantity -= to_move
	
	if from_slot.quantity <= 0:
		inventory[from_index] = null
	elif space <= 0:
		swap_slots(from_index, to_index)
	
	on_inventory_change.emit()
#endregion
