extends PointLight2D

@export var noise: NoiseTexture2D
var timePass := 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timePass += delta
	
	var sampled_noise = noise.noise.get_noise_1d(timePass)
	pass
