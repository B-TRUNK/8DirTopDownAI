extends Node2D

# 1 - need to detect the bullets scene location
@export var bullet_scene : PackedScene


func _on_player_shoot(pos ,dir):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir.normalized()
	#add all bullets to a group to work with as a bulk
	bullet.add_to_group("bullets")
