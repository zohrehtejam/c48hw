extends RigidBody2D
class_name Bullet

export var speed := 500

func _on_Bullet_body_entered(body: Node) -> void:
	if body.has_method("explode"):
		body.explode()
		queue_free()
