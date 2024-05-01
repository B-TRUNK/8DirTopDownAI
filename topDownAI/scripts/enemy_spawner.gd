extends Node2D

# 7 - to create a var for main theme as soon as start to be able to work with here
@onready var main = get_node("/root/Main")

# 11 - create a signal to forward to main when player get hit
signal hitP

# 1 - scene generator variable
var goblin_scene := preload("res://scenes/goblin.tscn")
# 2 - spawn points array
var spawn_points := []

func _ready():
	# 3 - to iterate throw each child inside this node except timer
	for i in get_children() :
		if i is Marker2D:
			spawn_points.append(i)


func _on_timer_timeout():
	#we handle enemy generation here
	# 4 - pick a random spawn point
	var rand_spawn = spawn_points[randi() % spawn_points.size()]
	# 5 - instantiate goblin scene
	var goblin = goblin_scene.instantiate() #this will span at (0,0)
	# 6-  to instantiate at specific spawn points:
	goblin.position = rand_spawn.position
	# 10 - return to goblin scene to call the hit signal
	goblin.hitPlayer.connect(hit)
	# 8 - generate
	main.add_child(goblin)

# 9 - recieve hit signal from goblin scene
func hit():
	hitP.emit()
