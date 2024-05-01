extends Area2D

@onready var main = get_node("/root/Main")
@onready var lives_label = get_node("/root/Main/Hud/LivesLabel")
@onready var player = get_node("/root/Main/Player")

# 1 - set items array
var item_type : int # 0:coffee ,1:health ,2:gun


var coffee_box = preload("res://assets/items/coffee_box.png")
var health_box = preload("res://assets/items/health_box.png")
var gun_box    = preload("res://assets/items/gun_box.png")

var textures = [coffee_box ,health_box ,gun_box]

func _ready():
	# 1 - Pick a texture according to goblin drop in goblin.gd
	$Sprite2D.texture = textures[item_type]


	# 2 : interacting with loot dropped
func _on_body_entered(body):
	
	#coffee:
	if (item_type == 0 and body.name == "Player"):
		body.boost()
	#health:
	elif (item_type == 1 and body.name == "Player"):
		main.lives += 1
		lives_label.text = "X" + str(main.lives)
	#gun:
	elif (item_type == 2):
		print("Gun Loot Picked!" and body.name == "Player")
		player.shoot_boost()
		
	#delete item which is picked
	queue_free()
