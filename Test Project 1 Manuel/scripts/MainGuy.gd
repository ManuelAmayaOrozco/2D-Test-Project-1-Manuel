extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const WALL_JUMP_PUSHBACK = 100
const WALL_SLIDE_GRAVITY = 100
var is_wall_sliding = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var double_jumping = false
var double_jumps = 1

var dying: bool = false

func die():
	dying = true

func _physics_process(delta):
	if !dying:
		if is_on_floor():
			double_jumping = false
			double_jumps = 1
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		if Input.is_action_just_pressed("jump") and not is_on_floor():
			if double_jumps != 0:
				velocity.y = JUMP_VELOCITY
				double_jumping = true
				double_jumps -= 1
		
		if Input.is_action_just_pressed("jump") and is_on_wall() and Input.is_action_pressed("move_right"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -WALL_JUMP_PUSHBACK
			
		if Input.is_action_just_pressed("jump") and is_on_wall(d) and Input.is_action_pressed("move_left"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -WALL_JUMP_PUSHBACK
			
		if is_on_wall() and !is_on_floor():
			if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
				is_wall_sliding = true
			else:
				is_wall_sliding = false
		else:
			is_wall_sliding = false
			
		if is_wall_sliding:
			velocity.y += (WALL_SLIDE_GRAVITY * delta)
			velocity.y = min(velocity.y, WALL_SLIDE_GRAVITY)

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("move_left", "move_right")
		
		if direction > 0:
			animated_sprite.flip_h = false
			collision_shape.position.x = abs(collision_shape.position.x)
		elif direction < 0:
			animated_sprite.flip_h = true
			collision_shape.position.x = abs(collision_shape.position.x)*-1
		
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			if not double_jumping:
				animated_sprite.play("jump")
			else:
				animated_sprite.play("double_jump")
			if is_on_wall():
				animated_sprite.play("wall_jump")

		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		move_and_slide()

	else:
		animated_sprite.play("death")
