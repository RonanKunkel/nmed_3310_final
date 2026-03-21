extends PointLight2D

@export var flickerSpeed: float = 2.0
@export var color_speed: float = 0.9
@export var energyMin: float = 0.95
@export var energyMax: float = 1.25
@export var radiusVariation: float = 0.03

@export var colorLow: Color = Color(1.0, 0.45, 0.1)
@export var colorHigh: Color = Color(1.0, 0.75, 0.4)

var baseEnergy: float
var baseRadius: float
var time: float = 0.0
var color_time: float = 0.0
func _ready():
	baseEnergy = energy
	baseRadius = texture_scale

func _process(delta):
	time += delta * flickerSpeed
	color_time += delta * color_speed
	# 4 sine functions at varying speeds 
	#to simulate random waves?
	var flicker = (
		sin(time * 1.0) * 0.4 +
		sin(time * 2.3) * 0.3 +
		sin(time * 5.7) * 0.2 +
		sin(time * 11.1) * 0.1
	)
	var color_flicker = (
		sin(color_time * 1.0)  * 0.4 +
		sin(color_time * 2.3)  * 0.3 +
		sin(color_time * 5.7)  * 0.2 +
		sin(color_time * 11.1) * 0.1
	)
	var t = (flicker +1.0) /2.0
	var color_t = (color_flicker + 1.0) / 2.0
	energy = lerp(energyMin,energyMax,t)
	texture_scale = baseRadius +flicker *radiusVariation
	color = colorLow.lerp(colorHigh,color_t)
	
	
