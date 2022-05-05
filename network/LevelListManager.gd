extends Label

signal level_selected

onready var itemList = get_parent().find_node("ItemList")
var wtl_files = []

var valid_filetypes = ['wtl', 'LV6', 'lv5', 'lev']

func _ready():
	reload_files()

func reload_files():
	"""
	Hunts for new WTL files.
	"""
	wtl_files = find_all_wtl_files()
	
	# Create buttons for the levelListMgr.
	itemList.clear()
	for name in wtl_files:
		itemList.add_item(name[1], null, true)

func on_index_click(i: int):
	emit_signal(
		"level_selected", wtl_files[i][0], wtl_files[i][1]
	)
	
"""
Directory accessors
"""

func find_all_wtl_files():
	var normal_files_in_directory = list_files_in_directory('.')
	var retlist = []
	for file_data in normal_files_in_directory:
		var filename = file_data[0]
		for filetype in valid_filetypes:
			if filename.ends_with('.' + filetype):
				retlist.append(file_data)
				break
	return retlist

	
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
			if not dir.current_is_dir():
				files.append([file, path + "/" + file])
			else:
				files.append_array(list_files_in_directory(path + "/" + file))

	dir.list_dir_end()

	return files
