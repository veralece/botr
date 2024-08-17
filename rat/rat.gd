extends Node3D
func play_walk():
	%AnimationPlayer.play("walk")

func stop_walk():
	%AnimationPlayer.play("RESET")
