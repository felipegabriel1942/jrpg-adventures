extends Node
class_name Inventory

var items: Dictionary = {}

func add_item(id: String, quantity: int = 1) -> void:
	if ItemDatabase.itens.has(id):
		items[id] = items.get(id, 0) + quantity
	else:
		push_error("Item ID '%s' not found on ItemDatabase." % id)

func remove_item(id: String, quantity: int = 1) -> void:
	if not items.has(id):
		return
		
	items[id] -= quantity
	
	if items[id] <= 0:
		items.erase(id)

func get_quantity(id: String) -> int:
	return items.get(id, 0)

func has_item(id: String, quantity: int = 1) -> bool:
	return get_quantity(id) >= quantity
	
func get_all_items() -> Dictionary:
	return items.duplicate()
