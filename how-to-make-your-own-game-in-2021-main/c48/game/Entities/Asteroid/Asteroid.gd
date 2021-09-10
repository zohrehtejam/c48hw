tool
extends RigidBody2D
class_name Asteroid

enum Size {
	BIG,
	MEDIUM,
	SMALL
}

const textures_by_size := {
	"BIG": [
		preload("res://Entities/Asteroid/Textures/meteorBrown_big1.png"),
		preload("res://Entities/Asteroid/Textures/meteorBrown_big2.png"),
		preload("res://Entities/Asteroid/Textures/meteorBrown_big3.png"),
		preload("res://Entities/Asteroid/Textures/meteorBrown_big4.png"),
		preload("res://Entities/Asteroid/Textures/meteorGrey_big1.png"),
		preload("res://Entities/Asteroid/Textures/meteorGrey_big2.png"),
		preload("res://Entities/Asteroid/Textures/meteorGrey_big3.png"),
		preload("res://Entities/Asteroid/Textures/meteorGrey_big4.png"),
	],
	"MEDIUM": [
		preload("res://Entities/Asteroid/Textures/meteorBrown_med1.png"),
		preload("res://Entities/Asteroid/Textures/meteorBrown_med3.png"),
		preload("res://Entities/Asteroid/Textures/meteorGrey_med1.png"),
		preload("res://Entities/Asteroid/Textures/meteorGrey_med2.png"),
	],
	"SMALL": [
		preload("res://Entities/Asteroid/Textures/meteorBrown_small1.png"),
		preload("res://Entities/Asteroid/Textures/meteorBrown_small2.png"),
		preload("res://Entities/Asteroid/Textures/meteorGrey_small1.png"),
		preload("res://Entities/Asteroid/Textures/meteorGrey_small2.png"),
	]
}
const collision_shapes_by_size := {
	"BIG": preload("res://Entities/Asteroid/CollisionShapeBig.tres"),
	"MEDIUM": preload("res://Entities/Asteroid/CollisionShapeMedium.tres"),
	"SMALL": preload("res://Entities/Asteroid/CollisionShapeSmall.tres"),
}

export(Size) var size := Size.BIG setget set_size
export var explode_speed := 300.0
export var max_initial_speed := 400.0
export var min_initial_speed := 100.0

func _ready() -> void:
	var initial_speed := rand_range(min_initial_speed, max_initial_speed)
	linear_velocity = Vector2(randf(), randf()).normalized() * initial_speed

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	$WrapAround.wrap(state, $Sprite)

func set_size(new_size: int) -> void:
	size = new_size
	var size_name = Size.keys()[size]
	var textures = textures_by_size[size_name]
	
	$CollisionShape2D.shape = collision_shapes_by_size[size_name]
	$Sprite.texture = textures[randi() % textures.size()]
	
func explode() -> void:
	if size != Size.SMALL:
		for i in range(2):
			var new_asteroid = duplicate()
			var offset_dir = PI * 2 * i
			new_asteroid.size += 1
			new_asteroid.linear_velocity = Vector2(explode_speed, 0).rotated(offset_dir)
			get_tree().root.add_child(new_asteroid)
		
	sleeping = true
	queue_free()
	EventBus.emit_signal("asteroid_exploded")
	


func _on_Asteroid_body_entered(body: Node) -> void:
	if body.has_method("hit"):
		body.hit()
		explode()
		EventBus.emit_signal("asteroid_exploded")
		
