extends Control

@onready var player : Player = Global.get_player()

func _ready() -> void:
	hide()


func _process(delta: float) -> void:
	if $Timer.is_stopped() == false:
		%RespawingLabel.text = "Respawning in: " + str(int($Timer.time_left))


func start() -> void:
	$Timer.start()
	show()


func _on_timer_timeout() -> void:
	hide()
	player.respawn()
