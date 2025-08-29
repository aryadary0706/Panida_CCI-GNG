extends Node

@onready var music_audio: AudioStreamPlayer = $AudioStreamPlayer

func play_music(stream: AudioStream):
	if music_audio.stream != stream:
		music_audio.stream = stream
		music_audio.play()

func play_loop_music(stream: AudioStream):
	if music_audio.stream != stream or not music_audio.playing:
		music_audio.stream = stream
		music_audio.play()
	   
	# Ensure the stream is not null before trying to access its loop property.
	if music_audio.stream:
		music_audio.stream.loop = true

func stop_music():
	if music_audio.playing:
		music_audio.stop()
