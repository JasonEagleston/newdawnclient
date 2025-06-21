extends Window

var stat_names = ["strength", "durability", "force", "resistance", "speed", "recovery", "energy"]

var race_to_icon = {"Human" = "white_male", "God" = "white_male"}

var available_races: Dictionary = {}
var selected_race: String = ""

var stat_values = {}

var points_left = 0

var labels: Dictionary = {}

var player_display_mob: Mob

func _ready() -> void:
	for name in self.stat_names:
		self.labels[name] = $StatPanel/GridContainer.find_child(name + "_mod")
		self.labels[name].text = "0.0"
		self.stat_values[name] = 0.0
	self.player_display_mob = Mob.new()
	var display: ColorRect = $StatPanel/PlayerDisplay
	$StatPanel/PlayerDisplay.add_child(self.player_display_mob)
	self.player_display_mob.position = Vector2(display.size.x / 2 - 32, display.size.y / 2 - 16)
	self.player_display_mob.set_icon("white_male", true)
	
func update_labels():
	for name in self.stat_names:
		self.labels[name].text = str(self.stat_values[name]) if self.stat_values[name] > 9 else "0" + str(self.stat_values[name])
	$StatPanel/points_remaining.text = points_text()


var reduce_vec: Vector2i = Vector2i(180, 0)

func try_back():
	if !$RaceList.is_visible_in_tree():
		into_race_panel()
	
func mod_stat(stat_name, up):
	pass

func set_races(races: Dictionary):
	self.available_races = races
	self.available_races.sort()
	$RaceList.clear()
	for key in available_races:
		$RaceList.add_item(key)
		
func default_stats():
	var race = self.available_races[self.selected_race]
	self.points_left = race.points
	for name in self.stat_names:
		self.stat_values[name] = race.stats[name]
	update_labels()
		
func points_text() -> String:
	return str(self.points_left) if self.points_left > 9 else  "0" + str(self.points_left)

func into_stat_panel():
	$RaceList.hide()
	$RaceDescriptionPanel.hide()
	$StatPanel.show()
	self.size -= reduce_vec
	self.position += (reduce_vec / 2)
	self.selected_race = $RaceList.get_item_text($RaceList.get_selected_items()[0])
	self.default_stats()
	self.update_labels()
	
	
	
func into_race_panel():
	$RaceList.show()
	$RaceDescriptionPanel.show()
	$StatPanel.hide()
	self.size += reduce_vec
	self.position -= (reduce_vec / 2)

func _on_next_button_pressed() -> void:
	self.into_stat_panel()


func _modifier_pressed(up: bool, stat: String) -> void:
	var race = self.available_races[self.selected_race]
	if self.points_left <= 0 or (up and self.stat_values[stat] >= race.max_stats[stat]) or (!up and self.stat_values[stat] <= race.stats[stat]):
		return
	self.stat_values[stat] = self.stat_values[stat] + 1 if up else self.stat_values[stat] - 1
	self.points_left = self.points_left - 1 if up else self.points_left + 1
	self.update_labels()


func _on_strength_down_pressed() -> void:
	_modifier_pressed(false, "strength")
func _on_strength_up_pressed() -> void:
	_modifier_pressed(true, "strength")
func _on_durability_down_pressed() -> void:
	_modifier_pressed(false, "durability")
func _on_durability_up_pressed() -> void:
	_modifier_pressed(true, "durability")
func _on_force_down_pressed() -> void:
	_modifier_pressed(false, "force")
func _on_force_up_pressed() -> void:
	_modifier_pressed(true, "force")
func _on_resistance_down_pressed() -> void:
	_modifier_pressed(false, "resistance")
func _on_resistance_up_pressed() -> void:
	_modifier_pressed(true, "resistance")
func _on_speed_down_pressed() -> void:
	_modifier_pressed(false, "speed")
func _on_speed_up_pressed() -> void:
	_modifier_pressed(true, "speed")
func _on_recovery_down_pressed() -> void:
	_modifier_pressed(false, "recovery")
func _on_recovery_up_pressed() -> void:
	_modifier_pressed(true, "recovery")
func _on_energy_down_pressed() -> void:
	_modifier_pressed(false, "energy")
func _on_energy_up_pressed() -> void:
	_modifier_pressed(true, "energy")


func _on_close_requested() -> void:
	try_back()


func _on_finished_pressed() -> void:
	get_tree().get_root().get_child(0).send_creation_stats()
