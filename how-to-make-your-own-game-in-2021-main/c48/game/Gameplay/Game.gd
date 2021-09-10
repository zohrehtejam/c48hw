extends Node2D

var Asteroid = preload("res://Entities/Asteroid/Asteroid.tscn")

onready var player := $Player

export var spawn_distance := 800

func _init() -> void:
	randomize()

func _ready() -> void:
	EventBus.connect("player_died", self, "_restart")
	spawn_asteroid()
	
func _restart() -> void:
	for asteroid in get_tree().get_nodes_in_group("asteroids"):
		asteroid.queue_free()
	get_tree().reload_current_scene()

func spawn_asteroid() -> void:
	var asteroid = Asteroid.instance()
	asteroid.position = player.position + Vector2(randf(), randf()).normalized() * spawn_distance
	add_child(asteroid)
