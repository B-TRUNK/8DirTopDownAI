extends Area2D

var direction : Vector2
var speed : int = 500

func _process(delta):
	#handle bullet movement
	position += direction * speed * delta


# below timer is to end object life cycle to not averflow memory
func _on_bullet_memory_death_timeout():
	queue_free()

# to detect collision
func _on_body_entered(body):
	if (body.name == "World" or body.name == "TileMap"):
		queue_free()
	else:
		if body.alive:
			body.die()
			queue_free()
