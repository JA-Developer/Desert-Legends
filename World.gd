extends Node2D

#We get the player`s node
onready var Player = get_node("Player")

#We get the Background`s node (BG) because we are going to 
#make it move with the camera, so It is going to look like
#the BG doesn`t move
#Note: See the function _process
onready var BG = get_node("BG")

#We load the Fireball Scene with the "preload" function,
#because we are going to create new instances later.
#Each instance will be one shooting
var Fireball = preload("res://FireBall.tscn")

#We load the TimerForFireball and create a boolean variable called
#ThePlayerCanShoot.
#We are going to use the timer for shooting every second
#And the boolean variable will disable the shooting till each second finishes
onready var TimerForFireBall = get_node("TimerForFireBall")
var ThePlayerCanShoot = true


#Get all the collision shapes to know where the player is colliding
onready var MiddleWoF = Player.get_child(2)
onready var MiddleWF = Player.get_child(3)
onready var BottomWoF = Player.get_child(4)
onready var BottomWF = Player.get_child(5)
onready var TopWoF = Player.get_child(6)
onready var TopWF = Player.get_child(7)

#This variable It's going to be useful to simulate the gravity
#It works in the same way as the Newton's laws
var FallingSpeed = 0;

#This variable saves when the player is in the floor
var IsOnFloor = false

#This variable saves when the player is in the ceiling
var IsOnCeiling = false

#This function is useful to disable all the collision shapes
#This has to be used before the "EnableRects" function because
#two kinds of Rectangles can't be enabled at the same time
func DisableAllRects():
	MiddleWoF.disabled=true;
	MiddleWF.disabled=true;
	BottomWoF.disabled=true;
	BottomWF.disabled=true;
	TopWoF.disabled=true;
	TopWF.disabled=true;

#As you know, each animation has different sizes
#So this function will enable and disable the proper rectangleshapes
#for each animation

#There are two kinds of rectangle shape, With flipping or Without fliping
#First we resize the rectangles and then we enable them
func EnableRects(Anim, Is_Flipped):
	
	if(Anim=="Idle"&&Is_Flipped==false):
		#We resize the rectangles
		TopWoF.shape.set_extents(Vector2(10,10))
		MiddleWoF.shape.set_extents(Vector2(10,10))
		BottomWoF.shape.set_extents(Vector2(10,10))
		
		#We enable them
		TopWoF.disabled=false;
		MiddleWoF.disabled=false;
		BottomWoF.disabled=false;
		
	elif(Anim=="Idle"&&Is_Flipped==true):
		#We resize the rectangles
		TopWF.shape.set_extents(Vector2(10,10))
		MiddleWF.shape.set_extents(Vector2(10,10))
		BottomWF.shape.set_extents(Vector2(10,10))
		
		#We enable them
		TopWF.disabled=false;
		MiddleWF.disabled=false;
		BottomWF.disabled=false;
	elif(Anim=="Run"&&Is_Flipped==false):
		#We resize the rectangles
		TopWoF.shape.set_extents(Vector2(18,10))
		MiddleWoF.shape.set_extents(Vector2(18,10))
		BottomWoF.shape.set_extents(Vector2(18,10))
		
		#We enable them
		TopWoF.disabled=false;
		MiddleWoF.disabled=false;
		BottomWoF.disabled=false;
	elif(Anim=="Run"&&Is_Flipped==true):
		#We resize the rectangles
		TopWF.shape.set_extents(Vector2(18,10))
		MiddleWF.shape.set_extents(Vector2(18,10))
		BottomWF.shape.set_extents(Vector2(18,10))
		
		#We enable them
		TopWF.disabled=false;
		MiddleWF.disabled=false;
		BottomWF.disabled=false;
	elif(Anim=="Jump"&&Is_Flipped==false):
		#We resize the rectangles
		TopWoF.shape.set_extents(Vector2(18,10))
		MiddleWoF.shape.set_extents(Vector2(18,10))
		BottomWoF.shape.set_extents(Vector2(18,10))
		
		#We enable them
		TopWoF.disabled=false;
		MiddleWoF.disabled=false;
		BottomWoF.disabled=false;
	elif(Anim=="Jump"&&Is_Flipped==true):
		#We resize the rectangles
		TopWF.shape.set_extents(Vector2(18,10))
		MiddleWF.shape.set_extents(Vector2(18,10))
		BottomWF.shape.set_extents(Vector2(18,10))
		
		#We enable them
		TopWF.disabled=false;
		MiddleWF.disabled=false;
		BottomWF.disabled=false;
	
func _ready():
	set_process(true)
	set_physics_process(true)

func _process(delta):
	#That moves the background with the camera
	BG.global_position = Player.get_child(0).get_camera_screen_center()

func _physics_process(delta):
	#This simulates the gravity, this adds 10 to the
	#velocity that the player has when is falling down
	FallingSpeed +=10
	
	#This simulates the gravity, this move the player
	#into the ground, using the Falling Speed
	var Collision = Player.move_and_collide(Vector2(0,FallingSpeed * delta))
	
	if(Collision):
		#If the player collided with his foots (BottomShape)
		if(Collision.local_shape.is_in_group("Foots")):
			#If the player was in the air when It collided with ground:
			if(IsOnFloor==false):
				#Restart the animation
				Player.get_child(1).frame=0
				#Set IsOnFloor = true
				IsOnFloor = true
			#As the player is in the ground, whe set the falling speed to 0
			FallingSpeed = 0
		#If the player collided with the head (TopShape)
		elif(Collision.local_shape.is_in_group("Head")):
			FallingSpeed = 0
	else:
		#But, if the player is not in the ground:
		IsOnFloor=false
		#If the player has the animation "Run"
		if(Player.get_child(1).animation=="Run"):
			#We stop the animation
			Player.get_child(1).stop()
	
	#If any key is pressed
	if(Input.is_key_pressed(KEY_W) || Input.is_key_pressed(KEY_A) || Input.is_key_pressed(KEY_D) || Input.is_key_pressed(KEY_SPACE)):
		#If the key "W" (Up) is pressed 
		if(Input.is_key_pressed(KEY_W)):
				#If the player is in the ground
				if(IsOnFloor):
					IsOnFloor = false
					#We apply an impulse to the player (Making the
					#FallingSpeed be negative)
					FallingSpeed -= 480
					
					#Now, we enable the proper rectangles for the animation
					DisableAllRects();
					EnableRects("Jump",Player.get_child(1).flip_h)
					
					#We run the "Jump" animation
					Player.get_child(1).play("Jump")
					
		#If the key "A" is pressed (Left)
		if(Input.is_key_pressed(KEY_A)):
			if(Player.get_child(1).flip_h==false):
				#If Player isn't flipped to the left, I mean, It'has the
				#flip_h false:
				#We move it to the Left because there's an error in the sprite
				#(Design). So that is necesary
				Player.move_and_slide(Vector2(-2000,0))
			
			#Now, we flip the player to the left	
			Player.get_child(1).flip_h=true
			#And we enable the proper rectangles:
			#Note: If the player is in the air, we can't use
			#the "Run" animation but we can use his rectangles because
			#they both have the same size
			DisableAllRects();
			EnableRects("Run",true)
		
			#We move the player to the left
			Player.move_and_slide(Vector2(-12000*delta,0))
			
			if(IsOnFloor):
				#If it's on the ground and the key "W" is pressed but
				#the player's animation isn't running or the player has
				#another animation
				if(Player.get_child(1).animation!="Run" || !Player.get_child(1).playing):
				#Then, play "Run" animation
					Player.get_child(1).play("Run")
			
		#If the key "D" is pressed (Right)
		if(Input.is_key_pressed(KEY_D)):
			#if Player isn't flipped to the right, I mean, It has the
			#flip_h true:
			#We move it to the Right because there's an error
			#in the sprite (Design). So that is necesary
			if(Player.get_child(1).flip_h==true):
				Player.move_and_slide(Vector2(2000,0))
			
			#Now, we flip the player to the right
			Player.get_child(1).flip_h=false
			#And we enable the proper rectangles:
			#Note: If the player is in the air, we can't use the "Run"
			#animation but we can use his rectangles because they both
			#have the same size
			DisableAllRects();
			EnableRects("Run",false)
		
			#We move the player to the right
			Player.move_and_slide(Vector2(12000*delta,0))
			
			if(IsOnFloor):
				#If it's on the ground and the key "W" is pressed but the
				#player's animation isn't running or the player has another
				#animation
				if(Player.get_child(1).animation!="Run" || !Player.get_child(1).playing):
					#Then, play "Run" animation
					Player.get_child(1).play("Run")
			
		#If the key "Space" is pressed (Shoot)
		if(Input.is_key_pressed(KEY_SPACE)):
			#We check if the player can shoot
			if(ThePlayerCanShoot == true):
				#We create a new Ball and add it to the Main node
				var Ball = Fireball.instance()
				add_child(Ball)
				
				if(Player.get_child(1).flip_h):
					#if the player is flipped to the left we set the direction of the ball to the left (-1)
					#Note: We created the "Direction" property using setget,
					#see the "FireBall" code
					Ball.Direction = -1
					#We put the ball at the left of the player and We flip it
					#to the left
					Ball.position = Vector2(Player.position.x-5,Player.position.y)
					Ball.get_child(0).flip_h=true;
					
				else:
					#if the player isn't flipped to the left we set the 
					#direction of the ball to the right (1)
					#Note: We created the "Direction" property using setget,
					#see the "FireBall" code
					Ball.Direction = 1
					#We put the ball at the right of the player and
					#We flip it to the right
					Ball.position = Vector2(Player.position.x+5,Player.position.y)
				
				#Now we disable the shooting for the player and start the timer
				ThePlayerCanShoot = false
				TimerForFireBall.start()
	else:
		if(Player.get_child(1).animation!="Idle" && IsOnFloor):
			#If isn't any keys pressed and the player is on the ground
			#but his animation isn't iddle
			#Then we enable the animation Iddle
			DisableAllRects();
			EnableRects("Idle",Player.get_child(1).flip_h)
			Player.get_child(1).play("Idle")

#This function runs when the timer completes one second
func _on_TimerForFireBall_timeout():
#We make the player be able to shoot
	ThePlayerCanShoot = true
