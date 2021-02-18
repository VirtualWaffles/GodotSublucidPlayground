extends Node2D

const SEGMENT = preload("res://Segment.tscn")

onready var Rope : Line2D = $Rope
var rope = []
var prev_rope = []

export var LENGTH = 20
export var DISTANCE = 10
export var ITERATIONS = 10

func _ready():
	for i in range(LENGTH):
		rope.append(Vector2.ZERO)
		prev_rope.append(Vector2.ZERO)
		Rope.add_point(rope[i])


func _physics_process(delta):
	# verlet integrate 
	# gives rope swingy momentum
	for i in range(1,LENGTH):
		var temp = rope[i]
		rope[i] += rope[i] - prev_rope[i]
		prev_rope[i] = temp
	
	# apply gravity
	for i in range(1,LENGTH):
		rope[i].y += 1
#		if i == LENGTH:
#			rope[i].y += 19
	
	# iterate to pull points closer together
	for j in range(ITERATIONS):
		for i in range(LENGTH - 1):
			var toNext = rope[i] - rope[i+1]
			if toNext.length() > DISTANCE:
				toNext = toNext.normalized() * DISTANCE
				var offset = rope[i] - rope[i+1] - toNext
				rope[i+1] += offset / 2
				rope[i] -= offset / 2
				
			if i == 0:
				rope[0] = get_global_mouse_position()

			# if point is farther away than it should from center, bring it in
			# handles long distance constraints reducing iterations
			# without this low iterations make rope "springy"
			rope[i+1] = LimitDistance(rope[i+1], get_global_mouse_position(), (i + 1) * DISTANCE)

			# how they did it (it just limits distance)
#			if (rope[i+1] - get_global_mouse_position()).length() > (i + 1) * DISTANCE:
#				rope[i+1] = get_global_mouse_position().move_toward(rope[i+1], (i + 1) * DISTANCE)

	# draw the rope
	updateRope(rope)


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


func updateRope(points):
	for i in range(LENGTH):
		Rope.set_point_position(i, points[i])
