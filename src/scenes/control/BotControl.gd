extends Node

var player: Player
var view_distance: float
var idle_point: Vector2

var delay: float = 2
var enemy_search_delay: float = 0.125

var _time_until_next_random_move: float = 0.0
var _time_until_next_enemy_search: float = 0.0
var _closest_enemy: Node

func _process(delta):
	_time_until_next_enemy_search -= delta
	if _time_until_next_enemy_search <= 0:
		_time_until_next_enemy_search = enemy_search_delay
		_closest_enemy = find_the_closest(player.position, 'Enemies', self.view_distance)
	player.step_vector = _compute_step_vector(delta)

func _compute_step_vector(delta: float) -> Vector2:
	if _closest_enemy != null:
		return _find_opposite_direction(player.position, _closest_enemy.position)
	
	_time_until_next_random_move -= delta
	if _time_until_next_random_move <= 0:
		_time_until_next_random_move = randf() * delay
		return _find_towards_direction(player.position, idle_point)
	
	return player.step_vector

func _find_opposite_direction(origin: Vector2, target: Vector2) -> Vector2:
	return (origin - target).normalized()

func _find_towards_direction(origin: Vector2, target: Vector2) -> Vector2:
	return (target - origin).normalized()

func find_the_closest(origin: Vector2, group: StringName, view_distance: float) -> Node:
	var closest = null
	var min_distance = INF
	
	for candidate in get_tree().get_nodes_in_group(group):
		var distance: float = origin.distance_to(candidate.position)
		
		if distance < min_distance:
			min_distance = distance
			closest = candidate
	
	return closest if min_distance <= view_distance else null
