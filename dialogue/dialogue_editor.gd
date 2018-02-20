extends Panel

#tool

var saved = true
var currentScene = 0

var f
var a
var dataEditor

var data
var assocs

var text
var background_sound
var background_image
var dialogue_sound
var size
var font
var color
var goto
var choices
var items
var id

var choices_assoc

func goto_page (n):
	if n >= 0 and n < data.size ():
		currentScene = n
		get_node ("VBoxContainer/SceneNumber/CurrentSceneNumber").get_line_edit ().set_text (String (n))
		load_page_data (n)
		set_editor_data ()

func save_page_data ():
	var x = data[currentScene]
	if background_image != null:
		x["b"] = background_image
	elif not dataEditor.get_node ("BackgroundImageData/CheckBox").is_pressed ():
		background_image = null
	if items != null:
		x["i"] = items
	elif not dataEditor.get_node ("ItemsData/CheckBox").is_pressed ():
		x["i"] = null
	if text != null:
		x["t"] = text
	elif not dataEditor.get_node ("TextData/CheckBox").is_pressed ():
		x["t"] = null
	if font != null and dataEditor.get_node ("FontData/CheckBox").is_pressed ():
		x["f"] = font
	if color != null and dataEditor.get_node ("ColorData/CheckBox").is_pressed ():
		x["c"] = color
	if size != null and dataEditor.get_node ("SizeData/CheckBox").is_pressed ():
		x["ts"] = size
	if dialogue_sound != null and dataEditor.get_node ("DialogueSoundData/CheckBox").is_pressed ():
		x["d"] = dialogue_sound
	if background_sound != null and dataEditor.get_node ("BackgroundSoundData/CheckBox").is_pressed ():
		x["s"] = background_sound
	if id != null and dataEditor.get_node ("IDData/CheckBox").is_pressed () and id != "":
		x["l"] = id
	if goto != null and dataEditor.get_node ("GotoData/CheckBox").is_pressed () and goto != "":
		x["g"] = goto
	if choices != null and choices != []:
		x["x"] = choices

func set_editor_data ():
	if (text != null):
		dataEditor.get_node ("TextData/CheckBox").set_pressed (true)
		dataEditor.get_node ("TextData/TextEdit").set_text (text)
	else:
		dataEditor.get_node ("TextData/CheckBox").set_pressed (false)
		dataEditor.get_node ("TextData/TextEdit").set_text ("")
	if (background_image != null):
		dataEditor.get_node ("BackgroundImageData/CheckBox").set_pressed (true)
		dataEditor.get_node ("BackgroundImageData/LinkButton").set_text (background_image)
	else:
		dataEditor.get_node ("BackgroundImageData/CheckBox").set_pressed (false)
	if (background_sound != null):
		dataEditor.get_node ("BackgroundSoundData/CheckBox").set_pressed (true)
		dataEditor.get_node ("BackgroundSoundData/LinkButton").set_text (background_sound)
	else:
		dataEditor.get_node ("BackgroundSoundData/CheckBox").set_pressed (false)
	if (dialogue_sound != null):
		dataEditor.get_node ("DialogueSoundData/CheckBox").set_pressed (true)
		dataEditor.get_node ("DialogueSoundData/LinkButton").set_text (dialogue_sound)
	else:
		dataEditor.get_node ("DialogueSoundData/CheckBox").set_pressed (false)
		dataEditor.get_node ("DialogueSoundData/LinkButton").set_text ("Pick Sound")
	if (font != null):
		dataEditor.get_node ("FontData/CheckBox").set_pressed (true)
		dataEditor.get_node ("FontData/LinkButton").set_text (font)
		var d = DynamicFontData.new ()
		d.set_path (font)
		var f = DynamicFont.new ()
		f.set_font_data (d)
		dataEditor.get_node ("FontData/PreviewLabel").get_theme ().set_default_font (f)
	else:
		dataEditor.get_node ("FontData/CheckBox").set_pressed (false)
		dataEditor.get_node ("FontData/LinkButton").set_text ("Pick Font")
	if (size != null):
		dataEditor.get_node ("SizeData/CheckBox").set_pressed (true)
		dataEditor.get_node ("SizeData/SpinBox").set_value (size)
	else:
		get_node ("VBoxContainer/DataEditor/SizeData/CheckBox").set_pressed (false)
	if (color != null):
		dataEditor.get_node ("ColorData/CheckBox").set_pressed (true)
		dataEditor.get_node ("ColorData/LineEdit").set_text (color)
		dataEditor.get_node ("ColorData/ColorPickerButton").set_pick_color (Color (color))
	else:
		dataEditor.get_node ("ColorData/CheckBox").set_pressed (false)
	if (choices != null):
		dataEditor.get_node ("ChoicesData/CheckBox").set_pressed (true)
		for i in choices:
			var x = i[0].insert (0, ": ".insert (0, i[1]))
			dataEditor.get_node ("ChoicesData/ItemList").add_item (x)
	else:
		dataEditor.get_node ("ChoicesData/CheckBox").set_pressed (false)
		dataEditor.get_node ("ChoicesData/ItemList").clear()
		dataEditor.get_node ("ChoicesData/LineEditText").set_text ("")
		dataEditor.get_node ("ChoicesData/LineEditGoto").set_text ("")
	if (id != null):
		dataEditor.get_node ("IDData/CheckBox").set_pressed (true)
		dataEditor.get_node ("IDData/LineEdit").set_text (id)
	else:
		dataEditor.get_node ("IDData/CheckBox").set_pressed (false)
		dataEditor.get_node ("IDData/LineEdit").set_text ("")
	if (goto != null):
		dataEditor.get_node ("GotoData/CheckBox").set_pressed (true)
		dataEditor.get_node ("GotoData/LineEdit").set_text (goto)
	else:
		dataEditor.get_node ("GotoData/CheckBox").set_pressed (false)
		dataEditor.get_node ("GotoData/LineEdit").set_text ("")
	if (items != null):
		dataEditor.get_node ("ItemsData/CheckBox").set_pressed (true)
		for i in items:
			dataEditor.get_node ("ItemsData/ItemList").add_item (i[0])
	else:
		dataEditor.get_node ("ItemsData/CheckBox").set_pressed (false)
		dataEditor.get_node ("ItemsData/ItemList").clear()
	
func load_page_data (i):
	var x = data[i]
	if x.has ("b"):
		background_image = x["b"]
	else:
		background_image = null
	if x.has ("i"):
		items = x["i"]
	else:
		items = null
	if x.has ("f"):
		font = x["f"]
	else:
		font = null
	if x.has ("t"):
		text = x["t"]
	else:
		text = null
	if x.has ("c"):
		color = x["c"]
	else:
		color = null
	if x.has ("ts"):
		size = x["ts"]
	else:
		size = null
	if x.has ("d"):
		dialogue_sound = x["d"]
	else:
		dialogue_sound = null
	if x.has ("s"):
		background_sound = x["s"]
	else:
		background_sound = null
	if x.has ("g"):
		goto = x["g"]
	else:
		goto = null
	if x.has ("l"):
		id = x["l"]
	else:
		id = null
	if x.has ("x"):
		choices = x["x"]
	else:
		choices = null
	
func _ready ():
	dataEditor = get_node ("VBoxContainer/DataEditor")
	var parser = XMLParser.new ()
	if parser.open (get_node ("/root/dialogue_loader").datafile) != 0:
		print ("Error Opening: ", "dialogue/data.xml")
		return null
	data = get_node ("/root/dialogue_loader").get_dialogue_data (parser)
	if data == null:
		print ("XML read failure")
		return
	get_node ("/root/dialogue_loader").meta = data[0]
	assocs = data[1]
	data = data[2]
	if data.size () == 0:
		print ("No scene data found")
		return
	get_node ("VBoxContainer/MainButtons/Label").set_text (get_node ("/root/dialogue_loader").datafile)
	dataEditor.get_node ("FontData/PreviewLabel").set_theme (Theme.new ())
	get_node ("VBoxContainer/SceneNumber/MaxLabel/").set_text ("Of: ".insert (4, String (data.size ())))
	get_node ("VBoxContainer/SceneNumber/CurrentSceneNumber/").set_max (data.size ())
	if  get_node ("/root/dialogue_loader").meta.has ("name"):
		get_node ("VBoxContainer/HBoxContainer/NameLineEdit").set_text ( get_node ("/root/dialogue_loader").meta["name"])
	if  get_node ("/root/dialogue_loader").meta.has ("version"):
		get_node ("VBoxContainer/HBoxContainer/VersionLineEdit").set_text ( get_node ("/root/dialogue_loader").meta["version"])
	if  get_node ("/root/dialogue_loader").meta.has ("url"):
		get_node ("VBoxContainer/HBoxContainer/UrlLineEdit").set_text ( get_node ("/root/dialogue_loader").meta["url"])
	if  get_node ("/root/dialogue_loader").meta.has ("author"):
		get_node ("VBoxContainer/HBoxContainer/AuthorLineEdit").set_text ( get_node ("/root/dialogue_loader").meta["author"])
	goto_page (0)

func _on_HSlider_changed ():
	goto_page (get_node ("VBoxContainer/SceneNumber/HSlider").get_value ())
	get_node ("VBoxContainer/SceneNumber/CurrentSceneNumber").set_value (get_node ("/root/Panel/").currentScene) 

func _on_CurrentSceneNumber_value_changed (value):
	var t = value
	#get_node ("/root/Panel/").goto_page (t + 1)
	get_node ("VBoxContainer/SceneNumber/HSlider").set_value (t)

func _on_SpinBox_value_changed (value):
	size = value
	dataEditor.get_node ("SizeData/CheckBox").set_pressed (true)

func _on_TextData_TextEdit_text_changed ():
	dataEditor.get_node ("TextData/CheckBox").set_pressed (true)
	text = dataEditor.get_node ("TextData/TextEdit").get_text ()

func _on_ColorData_LineEdit_text_changed (new_text):
	if new_text.is_valid_html_color ():
		color = new_text
		dataEditor.get_node ("ColorData/CheckBox").set_pressed (true)
		dataEditor.get_node ("ColorData/ColorPickerButton").set_pick_color (Color (new_text))
	else:
		if color != null:
			dataEditor.get_node ("ColorData/CheckBox").set_pressed (true)
			#dataEditor.get_node ("ColorData/LineEdit").set_text (color)
		else:
			dataEditor.get_node ("ColorData/CheckBox").set_pressed (false)
	
func _on_LoadButton_confirmed ():
	if f.get_current_path () != null:
		var parser = XMLParser.new ()
		if parser.open (f.get_current_path ()) != 0:
			print ("Error Opening: ", f.get_current_path ())
			return null
		data = get_node ("/root/dialogue_loader").get_dialogue_data (parser)
		if data == null:
			print ("XML read failure")
			f.queue_free ()
			f = null
			return
		get_node ("/root/dialogue_loader").meta = data[0]
		assocs = data[1]
		data = data[2]
		if data.size () == 0:
			print ("No scene data found")
			f.queue_free ()
			f = null
			return
		get_node ("/root/dialogue_loader").datafile = f.get_current_path ()
		get_node ("VBoxContainer/MainButtons/Label").set_text (get_node ("/root/dialogue_loader").datafile)
	goto_page (0)
	f.queue_free ()
	f = null
	
func _on_BackgroundImageLinkButton_confirmed ():
	if f.get_current_file () != null:
		background_image = f.get_current_path ()
		background_image.erase (0, 6) # Get rid of res://
		dataEditor.get_node ("BackgroundImageData/CheckBox").set_pressed (true)
		dataEditor.get_node ("BackgroundImageData/LinkButton").set_text (background_image)
		f.queue_free ()
		f = null

func _on_DialogueSoundLinkButton_confirmed ():
	if f.get_current_file () != null:
		dialogue_sound = f.get_current_path ()
		dialogue_sound.erase (0, 6) # Get rid of res://
		dataEditor.get_node ("DialogueSoundData/CheckBox").set_pressed (true)
		dataEditor.get_node ("DialogueSoundData/LinkButton").set_text (dialogue_sound)
		f.queue_free ()
		f = null

func _on_BackgroundSoundLinkButton_confirmed ():
	if f.get_current_file () != null:
		background_sound = f.get_current_path ()
		background_sound.erase (0, 6) # Get rid of res://
		dataEditor.get_node ("BackgroundSoundData/CheckBox").set_pressed (true)
		dataEditor.get_node ("BackgroundSoundData/LinkButton").set_text (background_sound)
		f.queue_free ()
		f = null

func _on_FontLinkButton_confirmed ():
	if f.get_current_file () != null:
		font = f.get_current_path ()
		font.erase (0, 6) # Get rid of res://
		dataEditor.get_node ("FontData/CheckBox").set_pressed (true)
		dataEditor.get_node ("FontData/LinkButton").set_text (font)
		var d = DynamicFontData.new ()
		d.set_path (font)
		var x = DynamicFont.new ()
		x.set_font_data (d)
		dataEditor.get_node ("FontData/PreviewLabel").get_theme ().set_default_font (x)
		f.queue_free ()
		f = null
		
func _on_ItemsLinkButton_confirmed ():
	if f.get_current_file () != null and items != null:
		var img = f.get_current_path ()
		img.erase (0, 6) # Get rid of res://
		dataEditor.get_node ("ItemsData/LinkButton").set_text (img)
		dataEditor.get_node ("ItemsData/ItemList").set_item_text (dataEditor.get_node ("ItemsData/ItemList").get_selected_items ()[0], img)
		items[dataEditor.get_node ("ItemsData/ItemList").get_selected_items ()[0]][0] = img
		f.queue_free ()
		f = null

func _on_SoundButton_finished ():
	a.stop ()
	a.queue_free ()
	a = null

func _on_GotoData_LineEdit_text_changed (new_text):
	dataEditor.get_node ("GotoData/CheckBox").set_pressed (true)
	goto = new_text

func _on_IDData_LineEdit_text_changed (new_text):
	dataEditor.get_node ("IDData/CheckBox").set_pressed (true)
	id = new_text

func _on_ChoicesData_LineEditGoto_text_changed (new_text):
	if choices != null:
		choices[dataEditor.get_node ("/ChoicesData/ItemList").get_selected_items ()[0]][0] = dataEditor.get_node ("ChoicesData/LineEditGoto").get_text ()
		var x = dataEditor.get_node ("ChoicesData/LineEditGoto").get_text ().insert (0, dataEditor.get_node ("ChoicesData/LineEditText").get_text ())
		dataEditor.get_node ("ChoicesData/ItemList").set_item_text (dataEditor.get_node ("ChoicesData/ItemList").get_selected_items ()[0], x)

func _on_ChoicesData_LineEditText_text_changed (new_text):
	if choices != null:
		choices[dataEditor.get_node ("ChoicesData/ItemList").get_selected_items ()[0]][1] = dataEditor.get_node ("ChoicesData/LineEditText").get_text ()
		var x = dataEditor.get_node ("ChoicesData/LineEditGoto").get_text ().insert (0, dataEditor.get_node ("ChoicesData/LineEditText").get_text ())
		dataEditor.get_node ("ChoicesData/ItemList").set_item_text (dataEditor.get_node ("ChoicesData/ItemList").get_selected_items ()[0], x)

func _on_ChoicesData_ItemList_item_activated (index):
	if choices != null:
		dataEditor.get_node ("ChoicesData/LineEditText").set_text (choices[index][1])
		dataEditor.get_node ("ChoicesData/LineEditGoto").set_text (choices[index][0])

func _on_ItemsData_ItemList_item_activated (index):
	if items != null:
		if (items[index][0] != ""):
			dataEditor.get_node ("ItemsData/LinkButton").set_text (items[index][0])
		else:
			dataEditor.get_node ("ItemsData/LinkButton").set_text ("Select Item Texture")
		dataEditor.get_node ("ItemsData/SpinBoxX").set_value (items[index][1])
		dataEditor.get_node ("ItemsData/SpinBoxY").set_value (items[index][2])

func _on_SpinBoxX_value_changed (value):
	if items != null and dataEditor.get_node ("ItemsData/ItemList").get_selected_items ().size () != 0:
		items[dataEditor.get_node ("ItemsData/ItemList").get_selected_items ()[0]][1] = value

func _on_SpinBoxY_value_changed (value):
	if items != null and dataEditor.get_node ("ItemsData/ItemList").get_selected_items ().size () != 0:
		items[dataEditor.get_node ("ItemsData/ItemList").get_selected_items ()[0]][2] = value

func _on_NameLineEdit_text_changed (new_text):
	get_node ("/root/dialogue_loader").meta["name"] = new_text

func _on_VersionLineEdit_text_changed (new_text):
	get_node ("/root/dialogue_loader").meta["version"] = new_text

func _on_UrlLineEdit_text_changed (new_text):
	get_node ("/root/dialogue_loader").meta["url"] = new_text

func _on_AuthorLineEdit_text_changed (new_text):
	get_node ("/root/dialogue_loader").meta["author"] = new_text
