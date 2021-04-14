extends Node

var scene_data = {}

func get_dialogue_data(file): #Pass path to file containing dialogue data of current scene
	var f = File.new ()
	if f.open (file, File.READ) != OK:
		return null 
	scene_data = parse_json(f.get_as_text())
	f.close()
	
	if (scene_data.get("meta") == null):
		return null
	else:
		if(scene_data.meta.get("version") == null):
			return null
		elif(scene_data.meta.get("encoding") == null):
			return null
		elif(scene_data.meta.get("author") == null):
			return null
		elif(scene_data.meta.get("game_name") == null):
			return null
		elif(scene_data.meta.get("scene") == null):
			return null
	if (scene_data.get("dialogue") == null):
		return null
	elif (scene_data.get("dialogue") == []):
		return null
	
	return scene_data
