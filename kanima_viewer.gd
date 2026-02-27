extends "res://scripts/window_snaps.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	%SubViewport.size = %kanimviewBackdrop.size



func _on_size_changed():
	%SubViewport.size = %kanimviewBackdrop.size
