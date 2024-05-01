extends CharacterBody2D

# 5 -1 access player node in root scene
@onready var player = get_node("/root/Main/Player")
@onready var main = get_node("/root/Main")

# 6 - create new area2d signal to detect collision between goblin and player
signal touch_player

var entered_map : bool
var speed		: int = 100
var direction 	: Vector2

var item_scene_rate = randi_range(0 ,1000)

# 9 - adding a way to die to Goblins
var alive : bool

# 10 - Loot Drop
var item_scene := preload("res://scenes/item.tscn")

# 11 - Explosion Scene
var explosion_scene := preload("res://scenes/explosion.tscn")


func _ready():
	var screen_rect = get_viewport_rect()
	alive = true
	entered_map = false
	# 1 - pick a direction to enterance
	#find a distance between goblin center point and game center point
	var distance = screen_rect.get_center() - position
	# 2 - check if needs to move horizontally or vertically
	if abs(distance.x) > abs(distance.y):
		#move horizontally
		direction.x = distance.x
		direction.y = 0
	else :
		#move vertically
		direction.y = distance.y
		direction.x = 0

func _physics_process(delta):
	
	if alive:
		# 7 - Add Running Animation to Goblins
		$AnimatedSprite2D.animation = "run"
		# 5 - we need to make goblins heading to center of player instead of map center
		if entered_map :
			direction = (player.position - position)
		# 4 - normalizing direction to not move goblins simultaniously
		direction = direction.normalized()
		# 3 - apply goblin AI Movement
		velocity = direction * speed
		move_and_slide()

		# 8 - to make goblins look right and left
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		pass
		
# 9 - 1 : handling goblin death
func die():
	alive = false
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	# also disable collision to stop collide after dying
	$Area2D/CollisionShape2D.set_deferred("disabled" ,true)
	if (item_scene_rate < 200):
		drop_item()
	else:
		pass
	var explosion = explosion_scene.instantiate()
	#explosion.position = position
	add_child(explosion)
	explosion.process_mode = Node.PROCESS_MODE_ALWAYS
	
# 10 - Loot Drop Mechanism
func drop_item():
	# 10 - 1
	var item = item_scene.instantiate()
	# 10 - 1
	item.position = position
	# # 10 - 2 : random texture select for item scene array
	item.item_type = randi_range(0 ,2)
	# 10 - 1
	main.call_deferred("add_child" ,item)
	# 10 - 1
	item.add_to_group("items")

func _on_entrance_timer_timeout():
	entered_map = true

# 6 - 1 emmit area2d collision signal
func _on_area_2d_body_entered(body):
	touch_player.emit()
