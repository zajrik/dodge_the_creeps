extends CanvasLayer

signal start_game

func show_message(text: String) -> void:
  $Message.text = text
  $Message.show()
  $MessageTimer.start()

func show_game_over() -> void:
  show_message('Game Over')
  await $MessageTimer.timeout

  $Message.text = 'Dodge the creeps!'
  $Message.show()

  # Wait one (1) second before displaying start button
  await get_tree().create_timer(1.0).timeout
  $StartButton.show()

## Update score label to the given value
func update_score(score: int) -> void:
  $ScoreLabel.text = str(score)

## Hide the message label on MessageTimer tick
func _on_message_timer_timeout() -> void:
  $Message.hide()

## Hide the start button and emit start_game
func _on_start_button_pressed() -> void:
  $StartButton.hide()
  start_game.emit()
