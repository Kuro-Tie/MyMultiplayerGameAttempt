extends Node
#The Nakama system connection is not working properly. Connection is working. But there are problems in rpc functions.
var scheme = "http"
var host = "127.0.0.1"
var port = 7350
var server_key = "defaultkey"
var client := Nakama.create_client(server_key, host, port, scheme)

var socket = Nakama.create_socket_from(client)
var multiplayer_bridge = NakamaMultiplayerBridge.new(socket)

func _ready():
	pass


func _on_LoginButton_pressed():
	var email = $UsernameText.text
	var password = $PasswordText.text
	$UsernameLabel.hide()
	$PasswordLabel.hide()
	$UsernameText.hide()
	$PasswordText.hide()
	$LoginButton.hide()
	$CreateMatchButton.show()
	$JoinMatch.show()
	# Use yield(client.function(), "completed") to wait for the request to complete.
	var session : NakamaSession = yield(client.authenticate_email_async(email, password), "completed")
	print(session)
	print(session.token) # raw JWT token
	print(session.user_id)
	print(session.username)

	socket.connect("connected", self, "_on_socket_connected")
	socket.connect("closed", self, "_on_socket_closed")
	socket.connect("received_error", self, "_on_socket_error")
	yield(socket.connect_async(session), "completed")
	print("Done")
	multiplayer_bridge.connect("match_join_error", self, "_on_match_join_error")
	multiplayer_bridge.connect("match_joined", self, "_on_match_joined")


	get_tree().set_network_peer(multiplayer_bridge.multiplayer_peer)
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")

func _on_network_peer_connected(peer_id):
	print ("Peer joined match: ", peer_id)

func _on_network_peer_disconnected(peer_id):
	print ("Peer left match: ", peer_id)

func _on_socket_connected():
	print("Socket connected.")

func _on_socket_closed():
	print("Socket closed.")

func _on_socket_error(err):
	printerr("Socket error %s" % err)

func _on_match_join_error(error):
	print ("Unable to join match: ", error.message)

func _on_match_joined() -> void:
	print ("Joined match with id: ", multiplayer_bridge.match_id)


func _on_Button_pressed():

	multiplayer_bridge.create_match()


func _on_JoinMatch_pressed():
	#I get match_id directly from nakama because i am unable to make match name var match is not working i could not do it
	var match_id = $EnterMatchID.text
	multiplayer_bridge.join_match(match_id)

remotesync func StartGame():
	get_tree().change_scene("res://Game.tscn")
	
func _on_gotoscene_pressed():
	rpc("StartGame") 
