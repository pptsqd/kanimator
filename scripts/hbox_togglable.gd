extends HBoxContainer


@export var start_locked : bool = false

func _ready():
	if start_locked:
		set_locked(true)

func set_locked(status):
	if status:
		for child in get_children():
			if "disabled" in child:
				child.disabled = true
			if "editable" in child:
				child.editable = false
	else:
		for child in get_children():
			if "disabled" in child:
				child.disabled = false
			if "editable" in child:
				child.editable = true
