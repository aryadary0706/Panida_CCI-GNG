extends Node
#Wave data 2
#Musuh yang ada: NT1, VT1, GLT, KGR, NT2, VT2
var wave_data = [
	# Wave 1
	{
		"max_spawn": 10,
		"enemies": [
			{ "type": "NT1", "count": 4 },
			{ "type": "VT1", "count": 4 },
			{ "type": "NT2", "count": 1 },
			{ "type": "VT2", "count": 1 },
		]
	},
	# Wave 2
	{
		"max_spawn": 10,
		"enemies": [
			{ "type": "NT1", "count": 4 },
			{ "type": "VT1", "count": 4 },
			{ "type": "NT2", "count": 1 },
			{ "type": "VT2", "count": 1 },
		]
	},
	# Wave 3
	{
		"max_spawn": 10,
		"enemies": [
			{ "type": "NT1", "count": 3 },
			{ "type": "VT1", "count": 4 },
			{ "type": "NT2", "count": 1 },
			{ "type": "VT2", "count": 1 },
			{ "type": "GLT", "count": 1 },
		]
	},
	#Wave 4
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "NT1", "count": 6 },
			{ "type": "VT1", "count": 6 },
			{ "type": "NT2", "count": 2 },
			{ "type": "VT2", "count": 1 },
		]
	},
	#Wave 5
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "NT1", "count": 5 },
			{ "type": "VT1", "count": 7 },
			{ "type": "VT2", "count": 3 },
		]
	},
	# Wave 6
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "NT1", "count": 4 },
			{ "type": "VT1", "count": 4 },
			{ "type": "NT2", "count": 4 },
			{ "type": "VT2", "count": 3 },
		]
	},
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "NT1", "count": 5 },
			{ "type": "VT1", "count": 3 },
			{ "type": "NT2", "count": 3 },
			{ "type": "VT2", "count": 2 },
			{ "type": "GLT", "count": 2 }
		]
	},
	{
		"max_spawn": 20,
		"enemies": [
			{ "type": "NT1", "count": 8 },
			{ "type": "VT1", "count": 8 },
			{ "type": "NT2", "count": 2 },
			{ "type": "VT2", "count": 2 },
		]
	},
	{
		"max_spawn": 20,
		"enemies": [
			{ "type": "NT1", "count": 7 },
			{ "type": "VT1", "count": 7 },
			{ "type": "NT2", "count": 3 },
			{ "type": "VT2", "count": 3 },
		]
	},
	{
		"max_spawn": 20,
		"enemies": [
			{ "type": "NT1", "count": 7 },
			{ "type": "VT1", "count": 5 },
			{ "type": "NT2", "count": 4 },
			{ "type": "VT2", "count": 3 },
			{ "type": "KGR", "count": 1 },
		]
	},
]

func get_wave_data(index: int) -> Dictionary:
	if index >= 0 and index < wave_data.size():
		return wave_data[index]
	return {}

func get_wave_data_size() -> int :
	return wave_data.size()
