extends Node2D

@onready var highlight_tile = $"../Highlight_tile"
@onready var towers = $"../Towers"
@onready var tile_map = $"../TileMapLayer"

var used_tiles: Array[Vector2i] = []

func _unhandled_input(event):
	if event.is_action_pressed("left_mouse"):
		var main = get_tree().get_root().get_node("Main")

		if main.selected_tower_scene != null and main.is_placing_tower and Game.money >= 10:
			
			var cell_pos: Vector2i = tile_map.local_to_map(tile_map.get_local_mouse_position())

			# Cek apakah tile bisa dibangun
			var tile_data = tile_map.get_cell_tile_data(cell_pos)
			if tile_data != null and tile_data.get_custom_data("buildable") == true:
				
				# ❌ Jika tile sudah digunakan, tolak
				if used_tiles.has(cell_pos):
					print("Tile sudah terisi")
					return

				# ✅ Lanjutkan placement
				var world_pos: Vector2 = tile_map.map_to_local(cell_pos)

				var placed_tower = main.selected_tower_scene.instantiate()
				placed_tower.global_position = world_pos
				placed_tower.get_node("Area").hide()
				towers.add_child(placed_tower)

				# ✅ Tambah ke tile yang sudah digunakan
				used_tiles.append(cell_pos)

				Game.money -= 10
				main.is_placing_tower = false
