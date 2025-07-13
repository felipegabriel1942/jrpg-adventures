extends Node2D

var inventory: Dictionary = {}

func update_item(item, amount):
	if inventory.has(item):
		inventory[item]["amount"] += amount
		
		if inventory[item]["amount"] <= 0:
			inventory.erase(item)
	else:
		inventory[item]["amount"] = amount

func add_item(item, amount):
	if !inventory.has(item):
		inventory[item] = { "item": Items.itens[item], "amount": amount }

func _ready():	
	add_item("potion", 2)
	add_item("throwing_knife", 1)
	add_item("granade", 1)
