extends Node

#tool

var engine_version = "1.0"
var game_name = ""
var game_version = ""
var game_url = ""
var game_author = ""
var datafile = "dialogue/data.xml"
var page = 0
var meta

func _ready ():
	pass

func get_dialogue_meta_data (parser):
	var m = {}
	while parser.get_node_name () != "meta" and parser.get_node_name () != "scenes":
		if parser.read () != OK:
			return null
	if parser.get_node_name () == "meta":
		for i in parser.get_attribute_count ():
			if (parser.get_attribute_name (i) == "name"):
				game_name = parser.get_attribute_value (i)
			if (parser.get_attribute_name (i) == "version"):
				game_version = parser.get_attribute_value (i)
			if (parser.get_attribute_name (i) == "url"):
				game_url = parser.get_attribute_value (i)
			if (parser.get_attribute_name (i) == "author"):
				game_author = parser.get_attribute_value (i)
			m[parser.get_attribute_name (i)] = parser.get_attribute_value (i)
	return m
	
func get_dialogue_data (parser):
	var e = 0
	var data = []
	var background
	var text
	var backgroundsound
	var dialoguesound
	var c = 0
	var a = {}
	var goto
	var y
	var id
	var z
	meta = get_dialogue_meta_data (parser)
	var indentFilter = RegEx.new ()
	indentFilter.compile ("[ \n\t]*")
	if meta == null:
		return null
	while parser.get_node_name () != "scenes":
		if parser.read () != OK:
			return null
	while e == 0:
		e = parser.read ()
		if parser.get_node_type () == XMLParser.NODE_ELEMENT and parser.get_node_name () == "scene_data":
			var i = null
			var d = {}
			dialoguesound = null
			backgroundsound = null
			background = null
			c = c + 1
			goto = null
			var x = []
			if parser.has_attribute ("id"):
				id = parser.get_named_attribute_value ("id")
				a[id] = c
				var l = parser.get_named_attribute_value ("id")
				d["l"] = l
			if parser.has_attribute ("goto"):
				var g = parser.get_named_attribute_value ("goto")
				d["g"] = g
			if parser.has_attribute ("background"):
				var b = parser.get_named_attribute_value ("background")
				if b.is_rel_path ():
					d["b"] = b
				else:
					print ("Invalid Background Image: ", b)
			if parser.has_attribute ("text"): # Alternative way of doing it
				d["t"] = parser.get_named_attribute_value ("text").xml_unescape ()
			if parser.has_attribute ("font"):
				var f = parser.get_named_attribute_value ("font")
				if f.is_rel_path ():
					d["f"] = f
				else:
					print ("Invalid Font Path: ", f)
			if parser.has_attribute ("size"):
				var ts = parser.get_named_attribute_value ("size")
				if ts.is_valid_integer ():
					d["ts"] = ts.to_int ()
				else:
					print ("Invalid Font Size: ", ts)
			if parser.has_attribute ("color"):
				var color = parser.get_named_attribute_value ("color")
				if color.is_valid_html_color ():
					d["c"] = color
				else:
					print ("Invalid Color: ", color)
			if parser.has_attribute ("backgroundsound"):
				var dx = parser.get_named_attribute_value ("backgroundsound")
				if dx.is_rel_path ():
					d["s"] = dx
				else:
					print ("Invalid Background Sound: ", dx)
			if parser.has_attribute ("dialoguesound"):
				var ds = parser.get_named_attribute_value ("dialoguesound")
				if ds.is_rel_path ():
					d["d"] = ds
				else:
					print ("Invalid Dialogue Sound: ", d)
			e = parser.read ()
			while parser.get_node_type () == XMLParser.NODE_TEXT and indentFilter.search (parser.get_node_data ()).get_string () == parser.get_node_data (): #
				e = parser.read ()
			if parser.get_node_type () == XMLParser.NODE_TEXT and not d.has ("t") and parser.get_node_data () != "": #
				d["t"] = parser.get_node_data ().xml_unescape ()
			e = parser.read ()
			while parser.get_node_type () == XMLParser.NODE_ELEMENT and parser.get_node_name () == "choice":
				if parser.has_attribute ("goto"):
					y = parser.get_named_attribute_value ("goto")
				e = parser.read ()
				z = false
				if parser.get_node_type () == XMLParser.NODE_TEXT:
					z = parser.get_node_data ()
					e = parser.read ()
					e = parser.read ()
					while parser.get_node_type () == XMLParser.NODE_TEXT and parser.get_node_data ().strip_edges ().length () == 0: #
						e = parser.read ()
				if z:
					x.append ([y, z])
			if x != []:
				d["x"] = x				
			if parser.get_node_type () == XMLParser.NODE_ELEMENT and parser.get_node_name () == "items":
				i = []
				e = parser.read ()
				# FIXME - hack to "eat" extra text node when there's whitespace before first <item>
				if parser.get_node_type () == XMLParser.NODE_TEXT:
					e = parser.read ()
				while parser.get_node_type () == XMLParser.NODE_TEXT and indentFilter.search (parser.get_node_data ()).get_string () == parser.get_node_data (): #
					e = parser.read ()
				while parser.get_node_type () == XMLParser.NODE_ELEMENT and parser.get_node_name () == "item":
					var s = ""
					if (parser.has_attribute ("image") and parser.get_named_attribute_value ("image").is_rel_path ()):
						s = parser.get_named_attribute_value ("image")
					y = 0
					if (parser.has_attribute ("x") and parser.get_named_attribute_value ("x").is_valid_integer ()):
						y = parser.get_named_attribute_value ("x").to_int ()
					z = 0
					if (parser.has_attribute ("y") and parser.get_named_attribute_value ("y").is_valid_integer ()):
						z = parser.get_named_attribute_value ("y").to_int ()
					e = parser.read ()
					if parser.get_node_type () == XMLParser.NODE_TEXT:
						e = parser.read ()
					if s != "":
						i.append ([s, y, z])
					while parser.get_node_type () == XMLParser.NODE_TEXT and indentFilter.search (parser.get_node_data ()).get_string () == parser.get_node_data (): #
						e = parser.read ()
				d["i"] = i
			data.append (d)
	return [meta, a, data]

func dump_data (datafile, data):
	var f = File.new ()
	if f.open (datafile, File.WRITE) != OK:
		return false
	f.store_string ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<meta")
	for i in meta:
		f.store_string ("\"".insert (0, (meta[i].insert (0, "=\"".insert (0, i.insert (0, " "))))))
	f.store_line ("/>\n<scenes>")
	for i in data:
		f.store_string ("  <scene_data")
		if i.has ("b"):
			f.store_string ("\"".insert (0, i["b"].insert (0, " background=\"")))
		if i.has ("f"):
			f.store_string ("\"".insert (0, i["f"].insert (0, " font=\"")))
		if i.has ("g"):
			f.store_string ("\"".insert (0, i["g"].insert (0, " goto=\"")))
		if i.has ("l"):
			f.store_string ("\"".insert (0, i["l"].insert (0, " id=\"")))
		if i.has ("ts"):
			f.store_string ("\"".insert (0, String (i["ts"]).insert (0, " size=\"")))
		if i.has ("c"):
			f.store_string ("\"".insert (0, i["c"].insert (0, " color=\"")))
		if i.has ("s"):
			f.store_string ("\"".insert (0, i["s"].insert (0, " backgroundsound=\"")))
		if i.has ("d"):
			f.store_string ("\"".insert (0, i["d"].insert (0, " dialoguesound=\"")))
		if i.has ("t") and (i.has ("i") and i["i"] != null) or (i.has ("x") and i["x"] != null):
			f.store_string ("\"".insert (0, i["t"].xml_escape ().insert (0, " text=\"")))
		f.store_string (">")
		if i.has ("i") and i["i"] != null:
			f.store_string ("\n    <items>\n")
			for x in i["i"]:
				f.store_string ("\"".insert (0, x[0].insert (0, "      <item image=\"")))
				f.store_string ("\"".insert (0, String (x[1]).insert (0, " x=\"")))
				f.store_line ("\"/>".insert (0, String (x[2]).insert (0, " y=\"")))
			f.store_string ("    </items>\n  ")
		if i.has ("x") and i["x"] != null:
			for x in i["x"]:
				f.store_string ("\"".insert (0, x[0].insert (0, "\n    <choice goto=\"")))
				f.store_string ("</choice>".insert (0, String (x[1]).insert (0, ">")))
			f.store_string ("\n  ")
		if i.has ("t") and not (i.has ("i") or i.has ("x")):
			f.store_string (i["t"].xml_escape ())
		f.store_line ("</scene_data>")
	f.store_line ("</scenes>")
	f.close ()
	return true
