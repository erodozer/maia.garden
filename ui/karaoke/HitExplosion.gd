extends CPUParticles2D

func set_emitting(v):
	.set_emitting(v)
	if not v:
		queue_free()
