extends Node2D

@onready var lullaby_vocals: AudioStreamPlayer2D = $LullabyVocals
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const AUDIO_START := 18.0 #starting of Audio
const AUDIO_END := 23.0 #ending of Audio time stamp

func _ready() -> void:
	# Character rising animation will be added separately.
	lullaby_vocals.play(AUDIO_START) #timestamp needs to be adjusted
	animation_player.play("rise_2")
	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(_delta: float) -> void: 
	if lullaby_vocals.playing and lullaby_vocals.get_playback_position() >= AUDIO_END: 
		lullaby_vocals.stop()

func _on_animation_finished(anim_name: String) -> void: 
	if anim_name == "rise_2":
		get_tree().change_scene_to_file("res://scenes/space_float.tscn")
