extends Node
@onready var music_audio: AudioStreamPlayer = $AudioStreamPlayer

func play_music(stream: AudioStream):
	if music_audio.stream != stream:
		music_audio.stream = stream
		music_audio.play()

func stop_music():
	if music_audio.playing:
		music_audio.stop()
