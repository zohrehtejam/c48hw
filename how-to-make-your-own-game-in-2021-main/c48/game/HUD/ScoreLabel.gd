tool
extends Label
class_name ScoreLabel

export var score := 0 setget update_score

func _ready() -> void:
	EventBus.connect("score_changed", self, "update_score")

func update_score(new_score: int) -> void:
	text = "Score: " + str(new_score)
	score = new_score

