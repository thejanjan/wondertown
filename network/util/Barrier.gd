extends Node
class_name Barrier

"""
A Barrier is a type of class that performs a callback once
all clients have gladly received their information.
"""

var callback_funcref = null
var callback_arglist = null
var ready_clients = []

var multiplayer_api = null

func _init(tree, callback_funcref, callback_arglist=[]):
	self.multiplayer_api = tree.get_multiplayer()
	self.callback_funcref = callback_funcref
	self.callback_arglist = callback_arglist
	
func client_ready(pid):
	# Sanity checks on the peer id.
	if pid in ready_clients:
		return
	
	# Add this client to the list.
	ready_clients.append(pid)
	
	# Are we ready to go?
	for pid in multiplayer_api.get_network_connected_peers():
		if pid in ready_clients:
			continue
		else:
			return
	
	# Seems so.
	callback_funcref.call_funcv(callback_arglist)
