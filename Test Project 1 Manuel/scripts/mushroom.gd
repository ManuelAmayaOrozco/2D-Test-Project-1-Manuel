extends CharacterBody2D

const SPEED = 60

var direction = -1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if (ray_cast_right.is_colliding()):
		direction = -1
		animated_sprite.flip_h = false
	if (ray_cast_left.is_colliding()):
		direction = 1
		animated_sprite.flip_h = true

	position.x += direction * SPEED * delta
	
	move_and_slide()
