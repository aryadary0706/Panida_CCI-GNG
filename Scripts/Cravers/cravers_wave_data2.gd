extends Node
#Wave data 2
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
	#Sampai sini karena blum ada craver lain
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
