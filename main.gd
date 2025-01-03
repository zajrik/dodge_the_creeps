extends Node

@export var mob_scene: PackedScene

var score: int

# Start in demo mode, allowing mobs to collide, creating silly intro and
# game over screens
var demo: bool = true

func _ready() -> void:
  # Start spawning mobs on the title screen for funsies
  $MobTimer.start()

## Stop ScoreTimer on game over, triggered by player getting hit
func game_over() -> void:
  $ScoreTimer.stop()

  # Enable demo-mode and enable collision for all current mobs
  demo = true
  get_tree().call_group('mobs', 'set_collision_mask_value', 1, true)

  $HUD.show_game_over()

## Reset score, set player start position and start the StartTimer countdown
func new_game() -> void:
  # Stop mob timer, delete remaining mobs
  $MobTimer.stop()
  get_tree().call_group('mobs', 'queue_free')

  # Enable player collision
  $Player/CollisionShape2D.disabled = false

  # Disable demo mode
  demo = false

  score = 0
  $HUD.update_score(score)
  $HUD.show_message('Get ready!')

  $Player.start($StartPosition.position)
  $StartTimer.start()

## Enable MobTimer and ScoreTimer when StartTimer ticks
func _on_start_timer_timeout() -> void:
  $ScoreTimer.start()
  $MobTimer.start()

## Increment score when ScoreTimer ticks
func _on_score_timer_timeout() -> void:
  score += 1
  $HUD.update_score(score)

## Spawn a mob when MobTimer ticks
func _on_mob_timer_timeout() -> void:
  # Instantiate mob scene
  var mob: RigidBody2D = mob_scene.instantiate()

  # Enable mob collision in temo mode
  if demo:
    mob.set_collision_mask_value(1, true)

  # Choose random spawn location by setting progress ratio to a random float
  var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation
  mob_spawn_location.progress_ratio = randf()

  # Set mob's direction perpendicular to path direction + some randomness
  var direction: float = mob_spawn_location.rotation + PI / 2
  direction += randf_range(-PI / 4, PI / 4)
  mob.rotation = direction

  # Set the mob's position to random location on the mob spawn path
  mob.position = mob_spawn_location.position

  # Set random velocity for the mob
  var velocity := Vector2(randf_range(150.0, 250.0), 0.0)
  mob.linear_velocity = velocity.rotated(direction)

  # Add the mob to this scene
  add_child(mob)

## Start a new game when HUD signals start_game
func _on_hud_start_game() -> void:
  new_game()
