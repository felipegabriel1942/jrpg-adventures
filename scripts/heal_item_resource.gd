extends ItemResource
class_name HealItemResource

func use(targets: Array[BaseCharacter] = []) -> void:
	for target in targets:
		target.health_component.heal(self.points)
	
	PlayerInventory.remove_item(self.id)
