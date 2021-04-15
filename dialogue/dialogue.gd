extends Control

var scene_file #Path to file containing dialogue data of current scene
var data
var assocs
var NameLabel
var LabelDialog
var BackgroundImage
var CharacterArea
var ItemArea
var DialogueSound
var DialogueControl
var BackgroundSound
var ButtonImageNext
var ButtonNext
var ButtonPrev
var Last
var choicesHistory = [] # This saves player choices for dialogue control
var nextActions
var DirPath
var page


var p

func choice (n):
	var dialogue = data.get("dialogue")
	
	choicesHistory.append (n)
	for c in DialogueControl.get_children ():
		DialogueControl.remove_child (c)
	for i in nextActions:
		InputMap.action_add_event ("next", i)
		DialogueControl.hide ()
	ButtonNext.set_disabled (false)
	ButtonImageNext.set_disabled (false)
	for i in dialogue.size():
		if dialogue[i].get("id") == n :
			page = i
			break
	go_to_page (page)

func go_to_page (i):
	var x = data.dialogue[i]
	var d = DynamicFontData.new ()
	var f = DynamicFont.new ()
	if x.get ("background"):
		BackgroundImage.set_texture (load (x.get("background")))
		clear_items () # We wont need extra items when changing scene
	if x.get ("items"):
		clear_items ()
		for item in (x.get("items")):
			add_item (item.get("path"), item.get("x"), item.get("y"))
	if x.get ("items") == []:
		clear_items ()
	if x.get ("sprites"):
		for sprite in (x.get("sprites")):
			add_character (sprite.path, 120, 30)
	if x.get ("sprites") == []:
		clear_characters()
	if x.get ("text"):
		LabelDialog.set_bbcode (x.get("text"))
	if x.get ("character"):
		NameLabel.set_text (x.get("character"))
	if x.get ("character") == "":
		NameLabel.set_text ("")
	if x.get ("font"):
		d.set_font_path ("res://" + x.get("font"))
		f.set_font_data (d)
		LabelDialog.get_theme ().set_default_font (f)
	if x.get ("size"):
		f = LabelDialog.get_theme ().get_default_font ()
		f.set_size (x.get("size"))
		LabelDialog.get_theme ().set_default_font (f)
	if x.get ("sound"):
		DialogueSound.stop ()
		DialogueSound.set_stream (load (x.get("sound")))
		DialogueSound.get_stream ().set_loop (false)
		DialogueSound.play ()
	else:
		DialogueSound.stop ()
	if x.get ("sound") and x.get("sound") != "":
		BackgroundSound.stop ()
		BackgroundSound.set_stream (load (x.get("sound")))
		BackgroundSound.play ()
	elif x.get ("sound") and x.get("sound") == "":
		BackgroundSound.stop ()
	if x.get ("jump"):
		Last = page
		for i in range(data.dialogue.size()):
			if data.dialogue[i].get("id") == x.get("jump") :
				page = i - 1
				break
	if x.get ("choices"):
		show_choice (x)
	else:
		for i in nextActions:
			InputMap.action_add_event ("next", i)

func add_item (img, posX, posY):
	if (img == "") :
		clear_items()
		return
	var r = load(img)
	var t = TextureRect.new ()
	t.set_texture (r)
	ItemArea.add_child (t)
	t.set_margin (MARGIN_LEFT, posX) 
	t.set_margin (MARGIN_TOP, posY) 
	
func add_character (img, posX, posY):
	if (img == "") :
		clear_characters()
		return
	var r = load(img)
	var t = TextureRect.new ()
	t.set_texture (r)
	CharacterArea.add_child (t)
	t.set_margin (MARGIN_LEFT, posX) 
	t.set_margin (MARGIN_TOP, posY) 

func clear_items ():
	for c in ItemArea.get_children ():
		ItemArea.remove_child (c)
		c.queue_free ()
	
func clear_characters ():
	for c in CharacterArea.get_children ():
		CharacterArea.remove_child (c)
		c.queue_free ()

func show_choice (x):
	DialogueControl.show ()
	ButtonImageNext.set_disabled (true)
	ButtonNext.set_disabled (true)
	for i in nextActions:
		InputMap.action_erase_event ("next", i)
	Last = page
	for i in x.choices:
			var b = Button.new ()
			DialogueControl.add_child (b)
			b.set_text (i.get("text"))
			var s = GDScript.new ()
			s.set_source_code ("extends Button\n\nfunc _pressed():\n\tget_node(\"/root/Control\").choice('"+String(i.get("jump"))+"')")
			s.reload ()
			b.set_script (s)

func next ():
	if page + 1 < data.dialogue.size ():
		page = page + 1
		go_to_page (page)
		ButtonPrev.set_disabled (false)
	else:
		var err = get_tree ().change_scene ("menu/menu.tscn")
		if err :
			print("Can't change scene!")

func prev ():
	if page > 0:
		page = page - 1
		go_to_page (page)
	ButtonNext.set_disabled (false)
	if DialogueControl.get_children () != []:
		for c in DialogueControl.get_children ():
			DialogueControl.remove_child (c)
		for i in nextActions:
			InputMap.action_add_event ("next", i)
		DialogueControl.hide ()
	var x = data.dialogue[page]
	if x.get ("background") == null:
		var i = page - 1
		while ((data.dialogue[i].get("background") == null) and i >= 0):
			i = i - 1
		if i >= 0:
			BackgroundImage.set_texture (load (data.dialogue[i].get("background")))
	if x.get ("sound") == null:
		var i = page - 1
		while ((data.dialogue[i].get("sound") == null) and i >= 0):
			print("page "+String(i))
			print(data.dialogue[i].get("sound"))
			i = i - 1
		if i >= 0 and (load ((data.dialogue[i].get("sound"))).get_path() != BackgroundSound.get_stream().get_path ()):
			BackgroundSound.stop ()
			if data.dialogue[i].get("sound") != "":
				BackgroundSound.set_stream (load (data.dialogue[i].get("sound")))
				BackgroundSound.play (0)
	if x.get ("items") == null:
		var i = page - 1
		while (data.dialogue[i].get("items") == null) and i >= 0:
			i = i - 1
		if i >= 0:
			clear_items ()
			for item in data.dialogue[i].items:
				add_item (item.get("path"), item.get("x"), item.get("y"))
	if x.get ("character") == null:
		var i = page - 1
		while (data.dialogue[i].get("character") == null) and i >= 0:
			i = i - 1
		NameLabel.set_text("")
		if i >= 0:
			NameLabel.set_text (data.dialogue[i].get("character"))
	if x.get ("sprites") == null:
		var i = page - 1
		while (data.dialogue[i].get("sprites") == null) and i >= 0:
			i = i - 1
		clear_characters()
		if i >= 0:
			for character_sprite in data.dialogue[i].sprites:
				add_character (character_sprite.path, 120, 30)

func _ready ():
	BackgroundImage = get_node ("Panel/PictNext/BackgroundImage")
	NameLabel = get_node("Panel/TextBox/NameTag")
	LabelDialog = get_node ("Panel/TextBox/RichTextLabel")
	DialogueSound = get_node ("Panel/DialogueSound")
	CharacterArea = get_node ("Panel/CharacterControl")
	ItemArea = get_node ("Panel/ItemControl")
	DialogueControl = get_node ("Panel/DialogueControl")
	BackgroundSound = get_node ("Panel/BackgroundSound")
	ButtonImageNext = get_node ("Panel/PictNext")
	ButtonNext = get_node ("Panel/ButtonNext")
	ButtonPrev = get_node ("Panel/ButtonPrev")
	DirPath = OS.get_executable_path().get_base_dir()
	scene_file = "dialogue/demo.json"
	page = 0
	var t = Theme.new ()
	var tn = Theme.new ()
	var d = DynamicFontData.new ()
	d.set_font_path ("res://dialogue/fonts/font.ttf") # Need to override the bitmap font with a vector font
	var f = DynamicFont.new ()
	f.set_font_data (d)
	f.set_size (20)
	t.set_default_font (f)
	tn.set_default_font (f)
	LabelDialog.set_theme (t)
	NameLabel.set_theme(tn)
	NameLabel.add_color_override("font_color","#001a33")
	data = get_node ("/root/dialogue_loader").get_dialogue_data (scene_file)
	if data == null:
		print ("JSON read failure")
	if(get_saves(DirPath) != []):
		get_node ("Menu/CenterContainer/VBoxContainer/Load").set_disabled (false)
	nextActions = InputMap.get_action_list ("next")
	go_to_page (page) # Needed for loading saved games
	set_focus_mode (FOCUS_ALL)
	grab_focus ()

func _input (event):
	if event.is_action_pressed ("next"):
		next ()
		accept_event ()
	elif event.is_action_pressed ("prev"):
		prev ()
		accept_event ()
	elif event.is_action_pressed ("menu"):
		if (not get_node ("Menu").is_visible()):
			get_node ("Menu").show ()
			get_node ("Panel").hide ()
			for i in nextActions:
				InputMap.action_erase_event ("next", i)
		else:
			get_node ("Menu").hide ()
			get_node ("Panel").show ()
			for i in nextActions:
				InputMap.action_add_event ("next", i)
		accept_event ()

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files
	
func get_saves(path):
	var dir = Directory.new()
	var files
	var f = File.new()
	var saves = []
	for i in range(20):
		saves.append("")
	if dir.dir_exists(path + "/saves"):
		if (list_files_in_directory(path+"/saves") != []):
			files = list_files_in_directory(path+"/saves")
			for file in files:
				if (file.begins_with("slot_") && file.ends_with(".sav")): 
					if (f.open (path+"/saves/"+file, File.READ) != OK):
						print("Cant open save file "+file)
					else:
						saves[int(file.lstrip("slot_").rstrip(".sav"))] = file
						f.close()
	else:
		print("Saves directory does not exist, creating...")
		dir.open(path)
		dir.make_dir("saves")
	return saves

func save_game(idx):
	var f = File.new()
	var time = OS.get_datetime()
	var nameweekday= ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	var namemonth= ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var dayofweek = time["weekday"]
	var day = time["day"]
	var month= time["month"]
	var year= time["year"]
	var hour= time["hour"]
	var minute= time["minute"]
	var second= time["second"]
	var date = str(nameweekday[dayofweek])+" "+str("%02d" % [day])+" "+str(namemonth[month-1])+" "+str(year)+" "+str("%02d" % [hour])+":"+str("%02d" % [minute])+":"+str("%02d" % [second])
	var savedata = {
		"game" : "",
		"version" : "",
		"date": "",
		"scene": "",
		"page": -1,
		"choices_history": []
	}
	
	if (f.open (DirPath+"/saves/slot_"+String(idx)+".sav", File.WRITE) != OK):
		popup_err("Couldn't open save file in slot "+idx)
		return false
	else:
		savedata.game = data.meta.get("game_name")
		savedata.version = data.meta.get("version")
		savedata.date = date
		savedata.scene = data.meta.get("scene")
		savedata.page = page
		if choicesHistory != []: 
			for choice in choicesHistory:
				savedata.choices_history[choice] = choicesHistory[choice]
		f.store_line(to_json(savedata))
		f.close ()
		return true

	
func load_game (idx):
	var f = File.new()
	var s = get_saves (DirPath)
	var savedata = {}
	if s == null or idx >= s.size ():
		return false
		
	if (f.open (DirPath+"/saves/"+"slot_"+str(idx)+".sav", File.READ) != OK):
		print("Can't open save file "+"slot_"+str(idx)+".sav")
		return false
	else:
		savedata = parse_json(f.get_line())
		f.close()
		if (savedata.page < 0):
			print("Load game failed - save file doesn't contain saved page!")
			return false
		if (savedata.game != data.meta.game_name):
			print("Error: incorrect save file for " + get_node ("/root/dialogue_loader").game_name)
			return false
		if (savedata.version != data.meta.version):
			print("Error: save file game version does not match current game version")
			return false
	page = savedata.page
	prev () # Reload items that may not be specified on current page
	next ()
	return true

func _on_SaveList_ItemList_item_activated (idx):
	if save_game (idx):
		get_node ("Menu").hide ()
		get_node ("Panel").show ()
		popup("Saved game in slot "+String(idx)+"!")
	else:
		popup_err("Could not save game in slot "+String(idx)+"!")
	p.queue_free ()
	
func _on_LoadList_ItemList_item_activated (idx):
	if load_game (idx):
		get_node ("Menu").hide ()
		get_node ("Panel").show ()
		popup("Loaded game from slot "+String(idx)+"!")
	else:
		popup_err("Could not load game from slot "+String(idx)+"!")
	p.queue_free ()
	#for i in nextActions:
	#	InputMap.action_add_event ("next", i)
	
func popup(text):
	var l = Label.new ()
	var x = PanelContainer.new ()
	var pd = PopupDialog.new ()
	l.set_text (text)
	x.add_child (l)
	pd.add_child (x)
	get_tree ().get_current_scene ().add_child (pd)
	pd.popup_centered (Vector2 (0, 0))
	
func popup_err(text):
	var l = Label.new ()
	var x = PanelContainer.new ()
	var pd = PopupDialog.new ()
	l.set_text (text)
	l.add_color_override ("font_color", Color("#fc0303"))
	x.add_child (l)
	pd.add_child (x)
	get_tree ().get_current_scene ().add_child (pd)
	pd.popup_centered (Vector2 (0, 0))

