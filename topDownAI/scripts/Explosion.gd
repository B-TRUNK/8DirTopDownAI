extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# 1
	emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 2
	if !emitting:
		queue_free()
