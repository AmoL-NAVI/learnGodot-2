extends Node
class_name HealthComponent

signal on_health_change(curr_health: float)
signal on_death

var max_health: float
var curr_health: float

func setup(value: float) -> void:
	max_health = value
	curr_health = value


func take_damage(value: float) -> void:
	if curr_health <= 0:
		return
	
	curr_health = max(curr_health - value, 0.0)
	on_health_change.emit(curr_health)
	
	if curr_health <= 0:
		on_death.emit()
		
