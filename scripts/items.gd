extends Node

const Item = preload("res://scripts/core/item.gd")

var itens: Dictionary = {
	"potion": Item.new("potion", "Poção", 4, Item.EffectType.HEAL, Item.TargetScope.SINGLE),
	"granade": Item.new("granade", "Granada", 5, Item.EffectType.DAMAGE, Item.TargetScope.MULTIPLE),
	"throwing_knife": Item.new("throwing_knife", "Faca de Arremesso", 4, Item.EffectType.DAMAGE, Item.TargetScope.SINGLE),
}

func get_key_by_name(target_name) -> String:
	for key in itens.keys():
		if itens[key]["name"] == target_name:
			return key

	return ""
