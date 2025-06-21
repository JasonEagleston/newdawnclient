extends PopupPanel

func set_text(text: String):
	$Label.text = text

func show_text(time, text):
	self.set_text(text)
	$Timer.start(time)
	self.show()
	


func _on_timer_timeout() -> void:
	self.hide()
	self.get_parent().remove_child(self)
