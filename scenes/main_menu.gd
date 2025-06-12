extends Node2D

@export var websocket_url = "ws://127.0.0.1:8080"

var socket = WebSocketPeer.new()

var clients: Array = []
var maps: Array = []

var is_connecting: bool = false

func try_connect(url):
	is_connecting = true
	var err = socket.connect_to_url(url)
	if err != OK:
		print("Unable to connect.")
		
func load_creation_menu():
	$CreationMenu.show()
		
func connected():
	load_creation_menu()
	$MainMenu.hide()

enum PacketType {
	LOGIN = 1,
	LOGOUT = 2,
	RACES = 3,
	MAPS = 4,
	CLIENT_SYNC = 5,
	CLIENT_MOVE_REQUEST = 6,
	UPDATE_CLIENT_POSITION = 7,
}
func get_string_mult(buf: PackedByteArray, pos: int) -> Array:
	var strl = buf[pos]
	var strings = []
	while true:
		strings.append(get_string(buf, pos))
		pos += strl + 1
		if pos != buf.size():
			strl = buf[pos]
			continue
		break
	return strings

func get_string(buf: PackedByteArray, pos: int) -> String:
	# Pos points to the size of the string represented by a u8. If the string is equal to the max size (255 - 4?) then it is split into multiple strings and recombined.
	var size = buf[pos]
	var s = buf.slice(pos + 1, pos + 1 + size).get_string_from_utf8()
	return s

func load_maps(buf: PackedByteArray, pos: int):
	# [STRING LENGTH, STRING, MAP WIDTH u16, MAP HEIGHT u16, [TILE_ID u16...MAP_SIZE], REPEAT?]
	var tiles = []
	var map_name = get_string(buf, pos)
	pos += 1 + buf[pos]
	var map_width = buf.decode_u16(pos)
	pos += 2
	var map_height = buf.decode_u16(pos)
	pos += 2
	for i in map_width * map_height:
		tiles.append(buf.decode_u16(pos))
		pos += 2
	var map = load("res://scenes/map.tscn").instantiate()
	map.hide()
	get_tree().get_root().add_child(map)
	map.load_map(map_name, map_width, map_height, tiles)
	maps.append(map)
	if pos != buf.size():
		load_maps(buf, pos)

func get_races(buf: PackedByteArray):
	# [RACE LIST LENGTH, STRING LENGTH, RACE NAME STRING, REPEAT?]
	var len = buf[1]
	var available_races = []
	for s in get_string_mult(buf, 2):
		available_races.append(s)
	$CreationMenu.set_races(available_races)
	

func add_client(data: PackedByteArray):
	self.clients.append(data.decode_u64(1))
func remove_client(data: PackedByteArray):
	self.clients.remove_at(self.clients.find(data.decode_u64(1)))
func sync_clients(data: PackedByteArray):
	var pos = 1
	while pos < data.size():
		print("POS", pos, data.size())
		var client_id = data.decode_u64(pos)
		print("CLIENT: ", client_id)
		clients.append(client_id)
		pos += 8
			
func send_move_vec():
	var data: PackedByteArray = [PacketType.CLIENT_MOVE_REQUEST, move_vec.x && 0xFF, move_vec.y && 0xFF]
	socket.send(data)
		
var move_vec: Vector2i
var old_move_vec: Vector2i
	
func _process(dt):
	socket.poll()
	
	if Input.is_action_pressed("DOWN") and Input.is_action_pressed("UP"):
		move_vec.y = 0
	elif Input.is_action_pressed("DOWN"):
		move_vec.y = 1
	elif Input.is_action_pressed("UP"):
		move_vec.y = -1
	else:
		move_vec.y = 0

	if Input.is_action_pressed("LEFT") and Input.is_action_pressed("RIGHT"):
		move_vec.x = 0
	elif Input.is_action_pressed("LEFT"):
		move_vec.x = -1
	elif Input.is_action_pressed("RIGHT"):
		move_vec.x = 1
	else:
		move_vec.x = 0

	var sockstate = socket.get_ready_state()
	if is_connecting:
		if sockstate == WebSocketPeer.STATE_OPEN:
			print("Connected!")
			is_connecting = false
			connected()
	if sockstate == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var data = socket.get_packet()
			# TYPE, LENGTH, VALUE usually. Some packets are just TYPE, VALUE of known size.
			var ptype: PacketType = data[0]
			if ptype == PacketType.LOGIN:
				add_client(data)
			elif ptype == PacketType.LOGOUT:
				remove_client(data)
			elif ptype == PacketType.RACES:
				get_races(data)	
			elif ptype == PacketType.MAPS:
				load_maps(data, 1)
			elif ptype == PacketType.CLIENT_SYNC:
				sync_clients(data)
			elif ptype == PacketType.CLIENT_MOVE_REQUEST:
				pass
			elif ptype == PacketType.UPDATE_CLIENT_POSITION:
				pass
	
	if move_vec != old_move_vec:
		send_move_vec()
				
	old_move_vec = move_vec


func _on_connect_pressed() -> void:
	try_connect(websocket_url)
