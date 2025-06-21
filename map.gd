extends Node2D

var tile_layers: Array = []
var width: int = 0
var height: int = 0
var map_name: String
var objects: Array = []

func alert():
	pass

func load_map(_name: String, width: int, height: int, tiles: Array):
	set_name(_name)
	height = height
	var tile_set: TileSet = preload("res://assets/new_tile_set.tres")
	self.tile_layers.clear()
	var l: TileMapLayer = TileMapLayer.new()
	l.set_tile_set(tile_set)
	for x in width:
		for y in height:
			var tile_id = tiles[(x - 1) + (y - 1) * width]
			var pos_y = 0
			while tile_id >= 32:
				pos_y += 1
				tile_id -= 32
			l.set_cell(Vector2i(x - 1, y - 1), 0, Vector2i(tile_id, pos_y))
	self.tile_layers.append(l)

func load_objects():
	pass
