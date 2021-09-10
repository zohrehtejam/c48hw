extends RigidBody2D
class_name Player

export var engine_thrust := 400.0
export var spin_thrust := 2500.0

onready var wrap_around := $WrapAround
onready var sprite := $Sprite
onready var thrusters := $Thrusters
onready var gun_position := $GunPosition

var thrust := Vector2.ZERO
var rotation_dir := 0
var health := 3
var score := 0

var Bullet = preload("res://Entities/Bullet/Bullet.tscn")

func _ready() -> void:
	EventBus.connect("asteroid_exploded", self, "increase_score")

func _process(delta: float) -> void:
	_update_thrust()
	_update_rotation_dir()
	_update_shooting()
	

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	applied_force = thrust.rotated(rotation)
	applied_torque = rotation_dir * spin_thrust
	wrap_around.wrap(state, sprite)


func _update_thrust() -> void:
	if Input.is_action_pressed("thrust"):
		thrust = Vector2(engine_thrust, 0)
	else:
		thrust = Vector2.ZERO
		
	thrusters.visible = thrust.length_squared() > 0

func _update_rotation_dir() -> void:
	if Input.is_action_pressed("rotate_left"):
		rotation_dir = -1
	elif Input.is_action_pressed("rotate_right"):
		rotation_dir = 1
	else:
		rotation_dir = 0

func _update_shooting() -> void:
	if Input.is_action_just_pressed("shoot"):
		var bullet = Bullet.instance()
		bullet.position = gun_position.global_position
		bullet.rotation = rotation
		bullet.linear_velocity = linear_velocity + Vector2(bullet.speed, 0).rotated(rotation)
		get_tree().root.add_child(bullet)

func hit() -> void:
	health -= 1
	EventBus.emit_signal("health_changed", health)
	
	if health <= 0:
		EventBus.emit_signal("player_died")

func increase_score() -> void:
	score +=1
	EventBus.emit_signal("score_changed", score)
