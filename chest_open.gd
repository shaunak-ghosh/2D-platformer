extends StaticBody2D
var opened = false

func _ready():
	$AnimatedSprite.play("closed")

func _on_Area2D_body_entered(body):
	if Input.is_action_pressed("Enter"):
		open()

func open():
	$AnimatedSprite.play("open")
	$Sound.play()
