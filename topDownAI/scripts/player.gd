extends CharacterBody2D

var speed : int
var screen_rect : Vector2

# 9 - 1 shooting Signal
signal shoot
# 9 - 2 : to limit the number of bullets
var can_shoot : bool

# 10 - Player Speed variables to apply when pick loot
const START_SPEED = 200
const BOOST_SPEED = 400

# 11 - Player shooting Speed variables to apply when pick loot
const NORMAL_SHOT_SPEED : float = 0.5
const BOOSTED_SHOT_SPEED : float = 0.2

func _ready():
	
	# 1 -  to center the player at the middle at game_start
	screen_rect = get_viewport().size
	reset_player_in_new_game()
	
func reset_player_in_new_game():
	can_shoot = true
	speed = START_SPEED
	position = screen_rect / 2
	# 11
	$ShotTimer.wait_time = NORMAL_SHOT_SPEED


func _get_input():
	# 2 - Keyboard Input
	var input_direction = Input.get_vector("left" ,"right" , "up" ,"down")
	# 3 - update Velocity
	velocity = input_direction.normalized() * speed #normalized() is to set diagonal speed the same as linear speed
	
	# 9 - Mouse Clicks for Bullets
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		# shoot , but we need a direction of bullets
		var bullet_direction = get_global_mouse_position() - position
		shoot.emit(position ,bullet_direction)
		# 9 - 3 : cool down
		can_shoot = false
		#using a timer to be able to shoot again bcoz prev. statement will prevent shooting again
		$ShotTimer.start()
		
		
func _physics_process(_delta):
	#player movement
	# 4 , 5
	_get_input()
	move_and_slide()
	# 6 - Limit Movement to screen size
	position = position.clamp(Vector2.ZERO ,screen_rect)
	# 7 - Player Animation
	if velocity.length() != 0 : #player is moving
		$AnimatedSprite2D.play()
	else : #player not moving
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1

	# 8 - Player Rotation
	#to move according to mouse ,directional movement is needed
	# 8-1 : need to know where the mouse is pointing
	var mouse_position = get_local_mouse_position()
	# 8-2 pointing to angle
	var angle = snappedf(mouse_position.angle() , PI / 4) / (PI / 4)
	angle = wrapi(int(angle) ,0 ,8)
	$AnimatedSprite2D.animation = "walk" + str(angle)

# 10 - Speed Boost Func
func boost():
	$BoostTimer.start()
	speed = BOOST_SPEED

func _on_shot_timer_timeout():
	can_shoot = true

# 10 - boost timer to back to normal speed
func _on_boost_timer_timeout():
	speed = START_SPEED
	
# 11 - Shooting Speed Boost Func
func shoot_boost():
	$ShotBoostTimer.start()
	$ShotTimer.wait_time = BOOSTED_SHOT_SPEED

# 11 - Shot Boost Timer expiry
func _on_shot_boost_timer_timeout():
	$ShotTimer.wait_time = NORMAL_SHOT_SPEED
