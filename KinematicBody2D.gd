extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#We create a "Direction" property for the fireball using setget,
#so we can modify it in other script

export (int) var Direction = 1 setget Set_Direction

func _ready():
	set_physics_process(true)

#We create the "Set_Direction" function that is assigned to the
#"Direction" property
func Set_Direction(DirectionToUse):
	#This fuction get the "Direction" value and set it to the variable
	Direction = DirectionToUse

func _physics_process(delta):
	#For default, this ball moves into the side that is assigned in "Direction"
	var Collision = move_and_collide(Vector2(2000 * Direction*delta,0))
	if(Collision):
		if(Collision.get_collider().is_in_group("Knight")):
			#If the ball collides with a knight
			#We hurt the knight
			Collision.get_collider().Hurt()
		#And then We remove the ball
		queue_free()