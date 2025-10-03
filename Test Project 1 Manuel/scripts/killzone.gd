extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	print("Oops you are dead")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	if body.has_method("die"):
		Engine.time_scale = 0.5
		body.die()
	timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
