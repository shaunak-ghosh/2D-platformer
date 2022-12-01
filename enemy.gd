extends KinematicBody2D

var velocity = Vector2()
export var direction = 1
export var DetectsCliffs = true
var health = 2
var backhurt = 0
var vel_x = 30
var knockback = false

func _ready():
	$AnimationPlayer.play("Move");
	if direction == -1:
		$Sprite.flip.h = true;
	$floor_checker.position.x = $Collision_main.shape.get_extents().x *direction

func _physics_process(delta):
	if  is_on_wall() or not $floor_checker.is_colliding() and is_on_floor() and DetectsCliffs == true:
		direction = direction * -1
		$Sprite.flip_h = not $Sprite.flip_h
		$floor_checker.position.x = $Collision_main.shape.get_extents().x * direction
		print("collided")
	
	velocity.y= 20 * 9.8
	velocity.x = vel_x*direction
	
	if knockback == true:
		vel_x = vel_x * -1
	elif knockback == false:
		vel_x = vel_x * 1

	move_and_slide(velocity, Vector2.UP)

func _on_Sides_checker_body_entered(body):
	if body.has_method("hurt"):
		body.hurt(position.x)
	
	if body.has_method("_ready"):
		body._ready()

func _on_Hurtbox_area_entered(area):
	health = health-1
	if health == 0:
		$Die_Sound.play()
		$AnimationPlayer.play("Die")
		direction = 0
		velocity.y = 0
		set_collision_layer_bit(4,false)
		set_collision_mask_bit(0,false)
		$Hurtbox.set_collision_layer_bit(4,false)
		$Hurtbox.set_collision_mask_bit(0,false)
		$Sides_checker.set_collision_layer_bit(4,false)
		$Sides_checker.set_collision_mask_bit(0,false)
		$Timer.start()
	else:
		knockback = true
		$Knockback_Timer.start()

func _on_Timer_timeout():
	queue_free()

func _on_Backhurtbox_area_entered(area):
	backhurt = 1

func _on_Knockback_Timer_timeout():
	vel_x = vel_x * 1
