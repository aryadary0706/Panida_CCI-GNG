extends CharacterBody2D

@export var speed = 200

var Health = 5

var target_stand: Node = null
var mengunjungi_stand := false
var timer_makan := 0.0
var durasi_makan := 2.0

var last_progress := 0.0
var path_follower: PathFollow2D = null

func _ready():
	path_follower = get_parent()
	if path_follower is PathFollow2D:
		last_progress = path_follower.progress
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mengunjungi_stand and target_stand:
		if global_position.distance_to(target_stand.global_position) > 10:
			var arah = (target_stand.global_position - global_position).normalized()
			velocity = arah * speed
			move_and_slide()
			
			timer_makan += delta
			Health -= delta * target_stand.BulletDamage
			
			if timer_makan >= durasi_makan or Health <= 0:
				stop_attack()
	else:
		if path_follower:
			path_follower.progress += speed * delta
			if path_follower.progress_ratio == 1:
				death()
				Game.health -= 5
	if Health <= 0:
		death()
		Game.money += 5
		

func start_attack(tower: Node):
	mengunjungi_stand = true
	target_stand = tower
	timer_makan = 0.0
	if path_follower:
		last_progress = path_follower.progress


func stop_attack():
	mengunjungi_stand = false
	target_stand = null
	timer_makan = 0.0
	if path_follower:
		path_follower.progress = last_progress

func death():
	get_parent().get_parent().queue_free()
