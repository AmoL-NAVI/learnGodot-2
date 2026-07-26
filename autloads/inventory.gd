extends Node

signal on_inventory_change
signal on_equipment_change

const INVENTORY_SIZE: int = 30

var inventory: Array[SlotData]


func _ready() -> void:
	inventory.clear()
	inventory.resize(INVENTORY_SIZE)


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


func get_slot(index: int) -> SlotData:
	if index >= 0 and index < inventory.size():
		return inventory[index]
	return null
