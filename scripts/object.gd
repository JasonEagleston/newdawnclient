class_name Mob extends Node2D

var stats: Dictionary = {}

var icon = null

func _ready() -> void:
	pass

func _init():
	pass
	
func set_icon(path: String, animated: bool):
	if animated:
		var icon: AnimatedSprite2D = AnimatedSprite2D.new()
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		icon.set_sprite_frames(load("res://assets/" + path + ".tres"))
		icon.set_scale(Vector2(4.0, 4.0))
		icon.set_animation("move_north")
		icon.play()
		self.add_child(icon)
	else:
		var icon: Sprite2D = null
		icon = Sprite2D.new()
