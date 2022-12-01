extends CanvasLayer

var coins = 0
func _ready():
	$Coins.text = String(coins)

func _on_Coin_coin_collected():
	coins = coins + 1
	_ready()


func _on_Fallzone_body_entered(body):
	pass # Replace with function body.
