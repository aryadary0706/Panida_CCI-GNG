extends Label

var elapsed_time: float = 0.0

var last_displayed_seconds: int = -1


func _process(delta: float) -> void:
	# Menambahkan waktu yang berlalu dari frame sebelumnya
	elapsed_time += delta

	# Konversi float ke integer untuk mendapatkan detik yang utuh
	var current_seconds = int(elapsed_time)

	# Perbarui teks hanya jika detik berubah
	if current_seconds != last_displayed_seconds:
		# Hitung menit dan detik
		var minutes = int(elapsed_time / 60)
		var seconds = int(elapsed_time) % 60
		
		# Format string menjadi MM:SS dengan angka nol di depan
		self.text = "Waktu: %02d:%02d" % [minutes, seconds]
		
		# Simpan detik yang baru ditampilkan
		last_displayed_seconds = current_seconds
