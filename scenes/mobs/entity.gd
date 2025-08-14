extends CharacterBody2D

@export var Name: String = "Craver"
@export var Type: String = "Normal" #normal atau Vegan
@export var Eat_duration: float = 2.0
@export var Stand_visit: int = 3
@export var Move_speed: float = 200.0
@export var Health_Loss: int = 5 
@export var Eat_distance: float = 64.0

var target_stand: Node = null
var timer_makan: float = 0.0
var state: String = "jalan"  # "jalan", "menuju_stand", "makan"

var last_progress: float = 0.0
var path_follower: PathFollow2D = null

func _ready():
	path_follower = get_parent()
	if path_follower is PathFollow2D:
		last_progress = path_follower.progress
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		"jalan":
			gerak_di_path(delta)
		"menuju_stand":
			menuju_stand(delta)
		"makan":
			makan_di_stand(delta)

func gerak_di_path(delta: float) -> void:
	if path_follower:
		path_follower.progress += Move_speed * delta
		if path_follower.progress_ratio >= 1.0:
			Game.health -= Health_Loss
			death()

func menuju_stand(delta: float) -> void:
	if not target_stand:
		state = "jalan"
		return
	
	var jarak = global_position.distance_to(target_stand.global_position)
	if jarak > Eat_distance:
		var arah = (target_stand.global_position - global_position).normalized()
		velocity = arah * Move_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		state = "makan"
		timer_makan = 0.0
		print(Name, " mulai makan di ", target_stand.name)

func makan_di_stand(delta: float) -> void:
	if not target_stand:
		state = "jalan"
		return
	
	timer_makan += delta
	
	if timer_makan >= Eat_duration:
		Stand_visit -= 1
		print(Name, " selesai makan. Sisa Stand_visit: ", Stand_visit)
		
		timer_makan = 0.0
		
		if Stand_visit <=0:
			Game.money +=5
			death()
			return
			
		state = "jalan"
		target_stand = null
		if path_follower:
			path_follower.progress = last_progress

func start_attack (tower: Node):
	if target_stand != null or state == "makan":
		return
	
	target_stand = tower
	state = "menuju_stand"
	if path_follower:
		last_progress = path_follower.progress
	print(Name, " mendekati stand ", tower.name)

func stop_attack():
	if state != "makan":
		state = "jalan"
	target_stand = null

func death():
	get_parent().get_parent().queue_free()
