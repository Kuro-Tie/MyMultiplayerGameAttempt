extends Control


const SERVER_PORT = 28960
const MAX_PLAYERS = 2
var SERVER_IP = "127.0.0.1"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _player_connected(_id):
	print("Connected puppet")
	get_tree().change_scene("res://Game.tscn")


func _player_disconnected(_id):
	print("disconnected")

func _connected_ok():
	print("Connected")

func _connected_fail(_id):
	print("client çıktı")

func _server_disconnected(_id):
	print("server gitti bakkala")

func _on_Create_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer



func _on_Join_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer


func _on_Enter_pressed():
	var text = $IPline.text
	_on_IPline_text_entered(text)


func _on_IPline_text_entered(new_text):
	SERVER_IP = new_text
