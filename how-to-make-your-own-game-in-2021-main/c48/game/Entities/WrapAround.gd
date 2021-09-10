extends Node
class_name WrapAround

onready var viewport_size := get_viewport().size

func wrap(state: Physics2DDirectBodyState, sprite: Sprite) -> void:
	var half_sprite_size = sprite.texture.get_size() * sprite.scale * 0.5
	var position = state.transform.origin
	
	if position.x > viewport_size.x + half_sprite_size.x:
		state.transform.origin.x -= viewport_size.x
	elif position.x < -half_sprite_size.x:
		state.transform.origin.x += viewport_size.x
		
	if position.y > viewport_size.y + half_sprite_size.y:
		state.transform.origin.y -= viewport_size.y
	elif position.y < -half_sprite_size.y:
		state.transform.origin.y += viewport_size.y
