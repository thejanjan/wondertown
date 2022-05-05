extends Node


"""
An I/O class for managing input and output of Wondertown level files (WTLs).
"""

const WondertownLevelData = preload("WondertownLevelData.gd")
const LV6Parser = preload("LV6Parser.gd")
const LV5Parser = preload("LV5Parser.gd")
const LEVParser = preload("LEVParser.gd")
var parsers = {}

func load_parsers():
	if not parsers:
		parsers = {
			'LV6': LV6Parser.new(),
			'lv5': LV5Parser.new(),
			'lev': LEVParser.new()
		}

func load_file(filename):
	"""
	Loads a WTL filename.
	Returns null if not found or file load error.
	Returns false if json read error.
	Returns the full json of the WTL otherwise.
	"""
	# Attempt to read the file.
	var data_class = null
	var file = File.new()
	if file.open(filename, File.READ) != OK:
		# File read failed!
		return null
	
	# Must we delegate to a parser?
	load_parsers()
	for parser_filetype in parsers:
		if filename.ends_with(parser_filetype):
			var parser = parsers[parser_filetype]
			data_class = parser.make_wld(file)
			break
	
	# Have we made our dataclass yet?
	if data_class == null:
		# Attempt to parse file as json.
		var parsed_json = JSON.parse(file.get_as_text())
		file.close()
		if parsed_json.error != OK:
			# Json load failed!
			return false
		
		# Return the full WTL dictionary.
		data_class = WondertownLevelData.new(parsed_json.result)
	
	# Return our result.
	return data_class
	
func save_file(filename, level_dictionary):
	"""
	Saves a WTL to a location given a level dictionary.
	Todo!
	"""
	pass
