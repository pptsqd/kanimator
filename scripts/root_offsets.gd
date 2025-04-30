extends Control



func _process(delta):
	%kanim_root.scale = Vector2(float(%ro_sx.text),float(%ro_sy.text))
	%kanim_root.position = Vector2(float(%ro_sx.text),float(%ro_sy.text))
