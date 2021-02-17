extends Node2D

const SEGMENT = preload("res://Segment.tscn")

var rope = []

var LENGTH = 10
var DISTANCE = 100

func _ready():
	for i in range(LENGTH):
		var node = SEGMENT.instance()
		rope.append(node)
		add_child(node)

func _physics_process(delta):
	rope[0].global_position = get_global_mouse_position()
	for i in range(1,LENGTH):
		rope[i].global_position = EnforceDistance(rope[i].global_position, rope[i-1].global_position, DISTANCE)


func EnforceDistance(point, anchor, distance):
#	point: current position
#	anchor: what we want to stay close to / away from
#	distance: maximum space between point and anchor
	 return ((point - anchor).normalized() * distance) + anchor

func LimitDistance(point, anchor, distance):
	if point.distance_to(anchor) < distance:
		return point
	return EnforceDistance(point, anchor, distance)


	
