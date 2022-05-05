extends Node


"""
An I/O class for managing input and output of Wondertown level files (WTLs).
"""


func load_file(filename):
	"""
	Loads a WTL filename.
	Returns null if not found or file load error.
	Returns false if json read error.
	Returns the full json of the WTL otherwise.
	"""
	# Attempt to read the file.
	var file = File.new()
	if file.open(filename, File.READ) != OK:
		# File read failed!
		return null
	
	# Attempt to parse file as json.
	var parsed_json = JSON.parse(file.get_as_text())
	file.close()
	if parsed_json.error != OK:
		# Json load failed!
		return false
	
	# Return the full WTL dictionary.
	return parsed_json.result
	
func save_file(filename, level_dictionary):
	"""
	Saves a WTL to a location given a level dictionary.
	Todo!
	"""
	pass
