extends Node

var itens: Dictionary = {}

func _ready() -> void:
	_load_all_items("res://resources/items")

func _load_all_items(path: String) -> void:
	var dir := DirAccess.open(path)
	
	for file in dir.get_files():
		if file.ends_with(".tres"):
			var item_resource = load(path + "/" + file)
			
			if item_resource is ItemResource:
				itens[item_resource.id] = item_resource
