extends Craver
class_name CraverKangguru

const ChildScene: PackedScene = preload("res://Objects/Cravers/cravers_kangguru_child.tscn")

@export var child_count: int = 3
@export var spawn_offset: float = 16.0
var _children_spawned := false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if not _children_spawned and assignedShop != null:
		_spawn_children()
		_children_spawned = true

func _spawn_children() -> void:
	if ChildScene == null:
		return
	var parent := get_tree().current_scene
	if parent == null:
		parent = get_tree().root

	for i in range(child_count):
		var child: Node2D = ChildScene.instantiate()
		var angle :float = (float(i) / max(1, child_count)) * TAU + randf() * 0.35
		var offset := Vector2.RIGHT.rotated(angle) * spawn_offset
		child.global_position = global_position + offset
		parent.add_child(child)
