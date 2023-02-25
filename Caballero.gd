extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#We get the Rays that are going to help us to know when the knight are in 
#the end of the plattform
onready var Ray_1 = get_node("Ray 1")
onready var Ray_2 = get_node("Ray 2")

#We get the knight
onready var Knight = get_node("Knight")

#We get the collisionshapes
onready var Pies = get_node("BottomShape")
onready var Right = get_node("RightShape")
onready var Left = get_node("LeftShape")

#We get the progressbar that shows the health of the knight

onready var Health = get_node("ProgressBar")

#This simulates the gravity.
#This is the speed that the knight has when is falling down
var FallingSpeed = 0;

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	#This simulates the gravity, this adds 10 to the
	#velocity that the knight has when is falling down
	FallingSpeed +=10
	
	#This simulates the gravity, this moves the knight into the gound
	var Collision = move_and_collide(Vector2(0,FallingSpeed * delta))
	
	#If the knight collides
	if(Collision):
		
		#If the knight collides with his foots
		if(Collision.local_shape==Pies):
			#We set the falling speed to 0
			FallingSpeed = 0
			
			#We create a variable to save the direction of the knight
			var Direction = 1
			#If the knight if flipped to the left:
			if(Knight.flip_h):
				#If Ray1 (Left) isn't colliding.
				if(!Ray_1.is_colliding()):
					#Then we flip the knight to the right
					Knight.flip_h = false
				else:
					#But if the knight is still colliding with the left ray,
					#we set the direction to the left
					Direction = -1
			#If the knight if flipped to the right:
			else:
				#If the Ray 2 (Right) isn't colliding
				if(!Ray_2.is_colliding()):
					#We flip the knight to the left
					Knight.flip_h = true
				else:
					#But if the knight is still colliding with the right ray,
					#we set the direction to the right
					Direction = 1
			
			#We move the knight using the variable "Direction"
			var Collision2 = move_and_collide(Vector2(Direction * 60*delta,0))
			
			#if the kinght has collided with something else
			if(Collision2):
				#If the knight has collided with the player
				if(Collision2.get_collider().is_in_group("Player")):
					#If the knight has collided with the same side that
					#He was moving to
					if(Collision2.local_shape == Right && !Knight.flip_h || Collision2.local_shape == Left && Knight.flip_h):
						#Run animation "Attak"
						Knight.play("Attack")
						#So, you can add here the code for set what happen when
						#the knight attack the player
						#..........
					else:
						Knight.flip_h = !Knight.flip_h
						Knight.play("Walk")
				else:
					Knight.flip_h = !Knight.flip_h
					Knight.play("Walk")
			else:
				Knight.play("Walk")
	
	
#This function runs when the player shoots to the knight
func Hurt():
	#We substract 10 to the health
	Health.value -= 10
	
	#If the health is 0 or less than 0
	if(Health.value <= 0):
		#The knight dies
		queue_free()
