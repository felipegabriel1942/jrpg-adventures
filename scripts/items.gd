extends Node

var itens: Dictionary = {
	"potion": {
		"name": "Poção",
		"points":  4,
		"effect_type": "heal",
		"target_scope": "single"
	},
	"granade": {
		"name": "Granada",
		"points": 5,
		"effect_type": "damage",
		"target_scope": "multiple"
	},
	"throwing_knife": {
		"name": "Faca de Arremesso",
		"points": 4,
		"effect_type": "damage",
		"target_scope": "single"
	}
}

func get_key_by_name(target_name) -> String:
	for key in itens.keys():
		if itens[key]["name"] == target_name:
			return key

	return ""
