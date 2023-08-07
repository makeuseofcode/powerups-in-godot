extends CharacterBody2D

var speed = 200
var score = 0

var timer_duration = 10
var power_up_active = false

var bar

func _ready():
	bar = get_parent().get_node("Label")

func _physics_process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	move_and_collide(velocity * delta)
	
	bar.text = "Collectibles: " + str(score / 20)

func _on_collectibles_body_entered(body):
	get_parent().get_node("Collectibles").queue_free()
	score += 20


func _on_powerups_body_entered(body):
	get_parent().get_node("Powerups").queue_free()
	power_up_active = true
	# Start the timer
	await get_tree().create_timer(10.0).timeout
	power_up_active = false

func _on_enemy_body_entered(body):
	if power_up_active:
		get_parent().get_node("Enemy").queue_free()
	else:
		queue_free()
