extends Node2D

@onready var lullaby_vocals: AudioStreamPlayer2D = $LullabyVocals
@onready var animation_player: AnimationPlayer = $RisingStar

const AUDIO_START := 23.5 #starting of Audio
const AUDIO_END := 29.0 #ending of Audio time stamp

func _ready() -> void:
	lullaby_vocals.play(AUDIO_START) #timestamp needs to be adjusted
	animation_player.play("enter_space")

func _physics_process(_delta: float) -> void: 
	if lullaby_vocals.playing and lullaby_vocals.get_playback_position() >= AUDIO_END: 
		lullaby_vocals.stop()
