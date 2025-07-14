extends ItemResource
class_name DamageItemResource

func use(targets: Array[BaseCharacter] = []) -> void:
	for target in targets:
		target.health_component.take_damage(points)
	
	PlayerInventory.remove_item(self.id)
