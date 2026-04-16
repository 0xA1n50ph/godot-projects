class_name InteractableBase extends StaticBody3D
## Base class for all interactable objects that the player can interact with.
## Extend this class and override interact() to create new interactable types.

signal interaction_started(player: Player)
signal interaction_ended


func interact(_player: Player) -> void:
	push_error("interact() must be overridden in " + get_script().resource_path)
	return


func is_in_use() -> bool:
	push_error("is_in_use() must be overridden in " + get_script().resource_path)
	return false
