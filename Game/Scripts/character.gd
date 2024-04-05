extends CharacterBody3D

@export var controlComponent: ControlComponent
@export var velocityComponent: VelocityComponent


func _ready():
	#velocityComponent.maxSpeed = 10
	pass
	
func _process(delta: float):
	controlComponent.handle_input(self, delta)
