tool
extends HBoxContainer
class_name HealthIndicator

export var health := 3 setget set_health

var HealthIcon = preload("res://HealthIcon.tscn")

func _ready() -> void:
	EventBus.connect("health_changed", self, "set_health")
	set_health(health)

func set_health(new_health: int) -> void:
	if new_health < 0:
		return
		
	var child_count = get_child_count()
	
	if child_count < new_health:
		for i in range(child_count, new_health):
			var child = HealthIcon.instance()
			add_child(child)
	elif child_count > new_health:
		for i in range(new_health, child_count):
			var child = get_child(i)
			child.queue_free()
			
	health = new_health
