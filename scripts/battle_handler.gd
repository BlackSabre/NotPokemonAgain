extends Node

var random_creature: CreatureBase = null
var creatures_folder_directory = "res://resources/creatures/"


func GetRandomEnemyCreature():
	var max_tries = 10
	var current_try = 0
	var files: Array =  DirAccess.get_files_at(creatures_folder_directory)	
	var random_index = randi() % files.size()
	
	if files.size() > 0:
		while random_creature == null && current_try < max_tries:
			current_try += 1
			print("Attempting load for: " + files[random_index])
			random_creature = ResourceLoader.load(creatures_folder_directory + files[random_index])
	
	if random_creature == null:
		print("Failed to get random creature")
	
	print(random_creature.name)
		
