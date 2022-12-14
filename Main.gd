extends Node

export (PackedScene) var mob_scene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")

func _on_MobTimer_timeout():
	#creation d'une nouvelle instance de monstre
	var mob = mob_scene.instance()
	
	#choisir un emplacement random sur le path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	#Direction perpendiculaire au path 
	var direction = mob_spawn_location.rotation + PI / 2
	
	#Mob position à un point random
	mob.position = mob_spawn_location.position
	
	#Mettre du random dans les directions
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#Choix de la velocité des mobs
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#Spawn du mob dans la main scene
	add_child(mob)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
