extends Node
#Wave data 3
var wave_data = [
	# Wave 1
	{
		"max_spawn": 10,
		"enemies": [
			{ "type": "normal", "count": 6 },
			{ "type": "vegan", "count": 4 }
		]
	},
	# Wave 2
	{
		"max_spawn": 10,
		"enemies": [
			{ "type": "normal", "count": 6 },
			{ "type": "vegan", "count": 4 }
		]
	},
	# Wave 3
	{
		"max_spawn": 10,
		"enemies": [
			{ "type": "normal", "count": 5 },
			{ "type": "vegan", "count": 5 }
		]
	},
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "normal", "count": 10 },
			{ "type": "vegan", "count": 5 }
		]
	},
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "normal", "count": 10 },
			{ "type": "vegan", "count": 5 }
		]
	},
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "normal", "count": 8 },
			{ "type": "vegan", "count": 5 },
			{ "type": "glutton", "count": 2 },
		]
	},
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "normal", "count": 8 },
			{ "type": "vegan", "count": 5 },
			{ "type": "glutton", "count": 2 },
		]
	},
	{
		"max_spawn": 20,
		"enemies": [
			{ "type": "normal", "count": 14 },
			{ "type": "vegan", "count": 6 },
		]
	},
	{
		"max_spawn": 20,
		"enemies": [
			{ "type": "normal", "count": 10 },
			{ "type": "vegan", "count": 10 },
		]
	},
	{
		"max_spawn": 20,
		"enemies": [
			{ "type": "normal", "count": 10 },
			{ "type": "vegan", "count": 8 },
			{ "type": "glutton", "count": 2 },
		]
	},
]

func get_wave_data(index: int) -> Dictionary:
	if index >= 0 and index < wave_data.size():
		return wave_data[index]
	return {}

func get_wave_data_size() -> int:
	var jumlah_cravers = 0
	for i in range(wave_data.size()):
		jumlah_cravers += wave_data[i]["max_spawn"]
	return jumlah_cravers
