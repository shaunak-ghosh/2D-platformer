extends Area2D

signal coin_collected
var coins = 0
var collected = false

func _on_Coin_body_entered(body):
	$AnimationPlayer.play("bounce")
	$CollisionShape2D.queue_free()
	body.add_coin()
	emit_signal("coin_collected")
	if collected == false:
		set_collision_mask_bit(0,false)
		$SoundCoinCollect.play()
		collected = true

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
