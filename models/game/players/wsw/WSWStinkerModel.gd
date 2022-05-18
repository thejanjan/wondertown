extends Spatial

var blink_range = [150, 300]
var blink_duration = 7

enum StinkerModel {
	STINKY = 1
	LOOF   = 2
	QOOKIE = 3
	PEEGUE = 4
}

enum StinkerEyeState {
	GAMER = 1
	DYING = 2
	BORED = 3
	BLINK = 4
}

var StinkerTextures = {
	StinkerModel.STINKY: {
		StinkerEyeState.GAMER: preload("res://models/game/players/wsw/stinky2.bmp"),
		StinkerEyeState.DYING: preload("res://models/game/players/wsw/stinky2b.bmp"),
		StinkerEyeState.BORED: preload("res://models/game/players/wsw/stinky2c.bmp"),
		StinkerEyeState.BLINK: preload("res://models/game/players/wsw/stinky2d.bmp")
	},
	StinkerModel.LOOF: {
		StinkerEyeState.GAMER: preload("res://models/game/players/wsw/loof.bmp"),
		StinkerEyeState.DYING: preload("res://models/game/players/wsw/loofb.bmp"),
		StinkerEyeState.BORED: preload("res://models/game/players/wsw/loofc.bmp"),
		StinkerEyeState.BLINK: preload("res://models/game/players/wsw/loofd.bmp")
	},
	StinkerModel.QOOKIE: {
		StinkerEyeState.GAMER: preload("res://models/game/players/wsw/qookie2a.bmp"),
		StinkerEyeState.DYING: preload("res://models/game/players/wsw/qookie2b.bmp"),
		StinkerEyeState.BORED: preload("res://models/game/players/wsw/qookie2c.bmp"),
		StinkerEyeState.BLINK: preload("res://models/game/players/wsw/qookie2d.bmp")
	},
	StinkerModel.PEEGUE: {
		StinkerEyeState.GAMER: preload("res://models/game/players/wsw/peegue2a.bmp"),
		StinkerEyeState.DYING: preload("res://models/game/players/wsw/peegue2b.bmp"),
		StinkerEyeState.BORED: preload("res://models/game/players/wsw/peegue2c.bmp"),
		StinkerEyeState.BLINK: preload("res://models/game/players/wsw/peegue2d.bmp")
	}
}
var AnimPrefixes = {
	StinkerModel.STINKY: 'stinky_',
	StinkerModel.LOOF: 'stinky_',
	StinkerModel.QOOKIE: 'stinky_',
	StinkerModel.PEEGUE: 'peegue_',
}

onready var AnimPlayer = $AnimationPlayer
var is_moving = false
var stinker_mesh = null
var stinker_model = null
var stinker_eye_texture = null
var current_animation = 'zero'
var _blink_timer = 0

func _ready():
	# find the stinker mesh
	for child in get_children():
		if child is MeshInstance:
			stinker_mesh = child
	
	# determine what model we are
	var material = stinker_mesh.get_surface_material(0)
	var curr_tex = material.albedo_texture
	for stinker_model in StinkerTextures:
		if StinkerTextures[stinker_model][StinkerEyeState.GAMER] == curr_tex:
			self.stinker_model = stinker_model
			break
	assert(stinker_model)

func _physics_process(delta):
	"""
	decide the current eye texture and apply
	"""
	var state = StinkerEyeState.GAMER
	handle_blink_timer()
	
	# set eye state
	var __bored = get_anim_of('bored')
	var __die   = get_anim_of('die')
	match current_animation:
		__bored:
			state = StinkerEyeState.BORED
		__die:
			state = StinkerEyeState.DYING
		_:
			# if we can blink, do it
			if _blink_timer < blink_duration:
				state = StinkerEyeState.BLINK
	
	# set tex state
	set_stinker_face(state)
	
	# now handle animation
	var anim = 'idle'
	if is_moving:
		anim = 'walk'
	
	# set animationplayer anim if necessary
	if (current_animation != anim):
		AnimPlayer.play(get_anim_prefix() + anim)
		current_animation = anim

"""
anim handler
"""

func get_anim_prefix():
	return AnimPrefixes[stinker_model]

func get_anim_of(name):
	return name + get_anim_prefix()

"""
face handler
"""

func handle_blink_timer():
	_blink_timer -= 1
	if _blink_timer < 1:
		_blink_timer = rand_range(blink_range[0], blink_range[1])

func set_stinker_face(state):
	var material = stinker_mesh.get_surface_material(0)
	stinker_eye_texture = StinkerTextures[stinker_model][state]
	# theoretically, this check will avoid unnecessary
	# changes to the albedo texture
	if material.albedo_texture != stinker_eye_texture:
		material.albedo_texture = stinker_eye_texture

"""
external read
"""

func set_moving_state(mode):
	is_moving = mode

func _on_AnimationPlayer_animation_started(anim_name):
	current_animation = anim_name
