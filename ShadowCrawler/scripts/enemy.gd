extends CharacterBody2D

@export var target: Node2D

var speed = 40
var acceleration = 7

@onready var navigation_agent: NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	_animated_sprite.play("run")
		
func _physics_process(delta):
	
	var direction = Vector2.ZERO
	
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, acceleration * delta)
	
	if direction.x < 0:
		_animated_sprite.flip_h = true
	else:
		_animated_sprite.flip_h = false
	
	move_and_slide()

var t = 0

func _on_timer_timeout():
	
	var proximity_range = 14
	var x_proximity = abs(global_position.x - target.global_position.x) < proximity_range
	var y_proximity = abs(global_position.y - target.global_position.y) < proximity_range
	if (x_proximity and y_proximity):
		print("Reached player!")
		get_tree().paused = true
	
	navigation_agent.target_position = target.global_position
	
	t += 1
	if (t == 20):
		_animated_sprite.play("attack")
		t = 0
	elif (t > 10):
		_animated_sprite.play("run")
