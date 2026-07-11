extends Node2D

@onready var lullaby_vocals: AudioStreamPlayer2D = $LullabyVocals
@onready var animation_player: AnimationPlayer = $RisingStar
@onready var into_star: AnimationPlayer = $IntoStar
@onready var camera: Camera2D = $Dev_Character/Camera2D

const AUDIO_START := 23.5 #starting of Audio
const AUDIO_END := 29.0 #ending of Audio time stamp

func _ready() -> void:
	lullaby_vocals.play(AUDIO_START) #timestamp needs to be adjusted
	animation_player.play("enter_space")
	animation_player.animation_finished.connect(_on_enter_space_finished)
	$Dev_Character/Necklace.necklace_clicked.connect(_on_necklace_clicked)
	into_star.animation_finished.connect(_on_star_opened)

func _physics_process(_delta: float) -> void: 
	if lullaby_vocals.playing and lullaby_vocals.get_playback_position() >= AUDIO_END: 
		lullaby_vocals.stop()
		
func _on_enter_space_finished(anim_name: String) -> void: 
	if anim_name == "enter_space":
		var tween = create_tween()
		tween.tween_property(camera, "zoom", Vector2(3.0,3.0), 1.5)
		
func _on_necklace_clicked() -> void: 
	into_star.play("opening_star")
	into_star.animation_finished.connect(_on_star_opened)
func _on_star_opened(anim_name: String) -> void: 
	if anim_name == "opening_star": 
		get_tree().change_scene_to_file("res://scenes/fps_scene.tscn")
