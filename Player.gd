extends KinematicBody2D

var coins = 0
var velocity = Vector2(0,0)
var knockback = Vector2()
var knockforce = 10
var animation_finished = 0
var attack = true
export var life = 1

const speedX = 121.5
const gravity = 18
const jumpForce = -329

export var health = 2

func _ready():
	if health > 0:
		$AnimationPlayer.play("Idle");
	elif health < 0:
		Die()
	elif health == 0:
		Die()

func _physics_process(delta):
	velocity.y = velocity.y + gravity
	if health != 0:
		if Input.is_action_pressed("ui_right"):
			velocity.x = speedX
			$AnimationPlayer.play("Walk")
			$Sprite.flip_h = false
		
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -speedX 
			$AnimationPlayer.play("Walk")
			$Sprite.flip_h = true
		
		elif Input.is_action_pressed("Attack") and $Sprite.flip_h == false and attack == true:
			$AnimationPlayer.play("Attack")
			$AttackTimer.start()
			$Sound_swing.play()
		
		elif Input.is_action_pressed("Attack") and $Sprite.flip_h == true and attack == true:
			$AnimationPlayer.play("Attack2")
			$AttackTimer.start()
			$Sound_swing.play()
			
		else:
			$AnimationPlayer.play("Idle")
		
		if not is_on_floor():
			$AnimationPlayer.play("Jump")
		
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = jumpForce
		
		velocity = move_and_slide(velocity, Vector2.UP)
		
		velocity.x = lerp(velocity.x,0,0.25)
	else:
		velocity.y = gravity;
		Die()

func add_coin():
	coins = coins+1

func hurt(var enemyPosX):
	if(health > 1):
		set_modulate(Color(255,255,255,255))
		$Hurt_time.start()
	if(health > 0):
		health = health -1
		
		velocity.y = jumpForce*0.5
	if $Sprite.flip_h == true:
		velocity.x = 300
	elif position.x > enemyPosX and $Sprite.flip_h == false:
		velocity.x = -300
	
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	
func _on_Hurt_time_timeout():
	set_modulate(Color.white)

func _on_SwordHit_area_entered(area):
	if area.is_in_group("hurtbox"):
		area.take_damage()

func _on_SwordHit2_area_entered(area):
	if area.is_in_group("hurtbox"):
		area.take_damage()
		
func _on_Timer_timeout():
	$Sprite/SwordHit/CollisionShape2D1.disabled = true
	$Sprite/SwordHit2/CollisionShape2D2.disabled = true
	attack = true

func Die():
	life -= 1
	set_collision_mask_bit(5,false)
	if animation_finished == 0 and is_on_floor():
		$AnimationPlayer.play("Die")
		$death_Timer.start()
		animation_finished = 1
		$GAME_OVER.start()

func _on_death_Timer_timeout():
	animation_finished = 1
	if animation_finished == 1:
		$AnimationPlayer.play("Empty")

func _on_GAME_OVER_timeout():
	get_tree().change_scene("res://GAME_OVER.tscn")
