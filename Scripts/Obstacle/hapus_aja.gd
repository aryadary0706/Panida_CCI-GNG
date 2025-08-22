extends Node
#Wave data 3
var wave_data = [
	# Wave 1
	{
		"max_spawn": 1,
		"enemies": [
			{ "type": "normal", "count": 1 },
			#{ "type": "vegan", "count": 4 }
		]
	}
]

func get_wave_data(index: int) -> Dictionary:
	if index >= 0 and index < wave_data.size():
		return wave_data[index]
	return {}
