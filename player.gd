extends Area2D

signal hit

@export var speed: int = 400
var screen_size: Vector2

func _ready() -> void:
  screen_size = get_viewport_rect().size

  # Start disabled and hidden
  $CollisionShape2D.disabled = true
  hide()

func _process(delta: float) -> void:
  var velocity := Vector2.ZERO

  # Set player velocity based on input
  if Input.is_action_pressed("move_up"):
    velocity.y -= 1
  if Input.is_action_pressed("move_down"):
    velocity.y += 1
  if Input.is_action_pressed("move_left"):
    velocity.x -= 1
  if Input.is_action_pressed("move_right"):
    velocity.x += 1

  # Set player animation based on velocity
  if velocity.x != 0:
    $AnimatedSprite2D.animation = 'walk'
    $AnimatedSprite2D.flip_v = false
    $AnimatedSprite2D.flip_h = velocity.x < 0
  elif velocity.y != 0:
    $AnimatedSprite2D.animation = 'up'
    $AnimatedSprite2D.flip_v = velocity.y > 0

  if velocity.length() > 0:
    velocity = velocity.normalized() * speed
    $AnimatedSprite2D.play()
  else:
    $AnimatedSprite2D.stop()

  # Update player position, clamped to screen
  position += velocity * delta
  position = position.clamp(Vector2.ZERO, screen_size)

## Hide player when hit, emit hit signal and disable collision shape
func _on_body_entered(_body) -> void:
  hide()
  hit.emit()
  $CollisionShape2D.set_deferred('disabled', true)

## Place player at given position, show player and enable collision shape
func start(pos: Vector2) -> void:
  position = pos
  show()
  $CollisionShape2D.disabled = false
