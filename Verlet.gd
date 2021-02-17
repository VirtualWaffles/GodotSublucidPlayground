extends Node2D

const SEGMENT = preload("res://Segment.tscn")

var rope = []
var prev_rope = []

var LENGTH = 5
var DISTANCE = 50

func _ready():
	for i in range(LENGTH):
		var node = SEGMENT.instance()
		rope.append(node)
		add_child(node)
		prev_rope.append(node.global_position)


func _physics_process(delta):
	
#	for i in range(1,LENGTH):
##		VerletIntegrate(rope[i].global_position, prev_rope[i])
#		# Apply gravity
##		rope[i].global_position.y += 5
#
#		var temp = rope[i].global_position
#		rope[i].global_position += rope[i].global_position - prev_rope[i]
#		prev_rope[i] = temp
	
	for i in range(1,LENGTH):
		rope[i].global_position.y += 10
	
	rope[0].global_position = get_global_mouse_position()
	for i in range(1,LENGTH):
		rope[i].global_position = LimitDistance(rope[i].global_position, rope[i-1].global_position, DISTANCE)


func EnforceDistance(point, anchor, distance):
	return ((point - anchor).normalized() * distance) + anchor

func LimitDistance(point, anchor, distance):
	if point.distance_to(anchor) < distance:
		return point
	return EnforceDistance(point, anchor, distance)

func VerletIntegrate(current, previous):
	var temp = current
	current += current - previous
	previous = temp
