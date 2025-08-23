extends Node
#Wave data 1
#Musuh yang ada: NT1, VT1, GLT, KGR
var wave_data = [
	# Wave 1
	{
		"max_spawn": 10,
		"enemies": [
			{ "type": "NT1", "count": 7 },
			{ "type": "VT1", "count": 3 }
		]
	},
	# Wave 2
	{
		"max_spawn": 10,
		"enemies": [
			{ "type": "NT1", "count": 5 },
			{ "type": "VT1", "count": 5 }
		]
	},
	# Wave 3
	{
		"max_spawn": 10,
		"enemies": [
			{ "type": "NT1", "count": 5 },
			{ "type": "VT1", "count": 4 },
			{ "type": "GLT", "count" : 1}
		]
	},
	# Wave 4
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "NT1", "count": 8 },
			{ "type": "VT1", "count": 7 }
		]
	},
	# Wave 5
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "NT1", "count": 3 },
			{ "type": "VT1", "count": 12 },
		]
	},
	# Wave 6
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "NT1", "count": 8 },
			{ "type": "VT1", "count": 7 }
		]
	},
	# Wave 7
	{
		"max_spawn": 15,
		"enemies": [
			{ "type": "NT1", "count": 6 },
			{ "type": "GLT", "count": 3 },
			{ "type": "VT1", "count": 6 },
			
		]
	},
	# Wave 8
	{
		"max_spawn": 20,
		"enemies": [
			{ "type": "NT1", "count": 9 },
			{ "type": "VT1", "count": 9 },
			{ "type": "GLT", "count": 2 },
		]
	},
	# Wave 9
	{
		"max_spawn": 20,
		"enemies": [
			{ "type": "NT1", "count": 8 },
			{ "type": "VT1", "count": 8 },
			{ "type": "GLT", "count": 4 },
		]
	},
	# Wave 10
	{
		"max_spawn": 20,
		"enemies": [
			{ "type": "NT1", "count": 9 },
			{ "type": "VT1", "count": 9 },
			{ "type": "GLT", "count": 1 },
			{ "type": "KGR", "count": 1 },
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
