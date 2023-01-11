extends Node2D

var sword_starting_rotation = 0
var swung = false
var won = false

func _ready():
	sword_starting_rotation = $player/sword.rotation_degrees

func _physics_process(delta):
	if not swung:
		if Input.is_action_pressed("ui_accept"):
			if $player/sword.rotation_degrees < 300:
				$player/sword.rotation_degrees += delta * 50.0
		elif Input.is_action_just_released("ui_accept"):
			swing()
	elif not won:
		if get_node("goblin").linear_velocity.length() < 0.3:
			get_tree().create_timer(1.0).connect("timeout", get_tree(), "reload_current_scene")

func swing():
	swung = true
	var power = $player/sword.rotation_degrees - sword_starting_rotation

	$player/sword.rotation_degrees = sword_starting_rotation
	get_node("goblin").apply_impulse(Vector2.ZERO, Vector2(1, -0.5) * power)
	get_node("goblin").apply_torque_impulse(power * 2.0)

func _on_hole_entered(body):
	won = true
	$applause.play()
	yield($applause, "finished")
	get_tree().reload_current_scene()
