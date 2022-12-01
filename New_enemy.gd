extends KinematicBody2D
var speedX = 10
const gravity = 10
var a
onready var p = $"../Player"
var velocity = Vector2(0,0)
var go = false

func _ready():
	pass

func _physics_process(delta):
	velocity.y += gravity
	velocity.x = speedX
	if go == true:
		velocity = move_and_slide(velocity)
	if not speedX == 0:
		go = false
		

func _on_Area2D_body_entered(body):
	if body.has_method("player"):
		go = true

#extends KinematicBody2D
var speed = 40
var motion = Vector2(0,0)
