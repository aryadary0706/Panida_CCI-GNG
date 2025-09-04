extends Node

const MAX_SFX_PLAYERS = 8

@onready var music_player: AudioStreamPlayer = $MusicPlayer
var sfx_players: Array[AudioStreamPlayer] = []

func _ready():
	# pastikan music_player diarahkan ke bus Music
	music_player.bus = "Music"

	# buat pool SFX dan arahkan ke bus SFX
	for i in MAX_SFX_PLAYERS:
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		sfx_players.append(p)

func play_music(stream: AudioStream, loop: bool = true):
	stream.loop = loop
	music_player.stream = stream
	music_player.play()

func stop_music():
	music_player.stop()

func play_sfx(stream: AudioStream):
	for p in sfx_players:
		if !p.playing:
			p.stream = stream
			p.play()
			return
	# kalau semua sibuk → pakai yg pertama (replace)
	sfx_players[0].stop()
	sfx_players[0].stream = stream
	sfx_players[0].play()
