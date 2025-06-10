extends Node2D

@export var websocket_url = "ws://127.0.0.1:8080"

var socket = WebSocketPeer.new()

var clients: Array = []

var is_connecting: bool = false

func try_connect(url):
	is_connecting = true
	var err = socket.connect_to_url(url)
	if err != OK:
		print("Unable to connect.")
func connected():
	add_child(preload("res://scenes/demo.tscn").instantiate())
func _ready():
	try_connect(websocket_url)

enum PacketType {
	LOGIN = 1,
	LOGOUT = 2,
	RACES = 3,
	MAPS = 4,
}

func get_string(buf: PackedByteArray, pos: int, multi: bool) -> String:
	# Pos points to the size of the string represented by a u8. If the string is equal to the max size (255 - 4?) then it is split into multiple strings and recombined.
	if multi:
		var count = buf[pos]
		pos += 1
		for i in count:
			print(pos)
			get_string(buf, pos, false)
			pos += buf[pos] + 1
		return ""
	var size = buf[pos]
	var s = buf.slice(pos + 1, pos + 1 + size).get_string_from_utf8()
	return s
func load_maps(buf: PackedByteArray, pos: int):
	# [STRING LENGTH, STRING, MAP SIZE u16, [TILE_ID u16...MAP_SIZE], REPEAT?]
	var map_name = get_string(buf, pos, false)
	pos += 1 + buf[pos]
	var map_size = buf.decode_u16(pos)
	pos += 2
	for i in map_size:
		var tile_id = buf.decode_u16(pos)
		pos += 2
	if pos != buf.size():
		load_maps(buf, pos)

func add_client(data: PackedByteArray):
	self.clients.append(data.decode_u64(1))
func remove_client(data: PackedByteArray):
	self.clients.remove_at(self.clients.find(data.decode_u64(1)))
	
func _process(dt):
	socket.poll()
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
				print("RACES")
			elif ptype == PacketType.MAPS:
				load_maps(data, 1)
				
				
