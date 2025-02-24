extends Node

# Dictionary of dictionary. Each entry in upper dict is a player, and in the lower dict we have 3 keys:
# player_name, unique_id, player_num
# might merge name and player_num soon.
var players = {}


var p1_unique_id: int = -1
var p2_unique_id: int = -1

func save_unique_id(id: int):
	if id == 1:
		p1_unique_id = id
	else:
		p2_unique_id = id
