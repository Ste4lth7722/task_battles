extends Control

## Initial note: This multiplayer is very janky and has lots of redundancy. I will fix this when I have a better understanding of proper implementation.
## Also im pretty sure this entire script is destroyed when we enter a level but I don't know if this actually matters

@export var address: String = "127.0.0.1" # Temporary Address
@export var port: int = 8910 # Temporary?

@onready var game = $"../.."

var peer

var current_players: int = 0

func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


func _process(_delta: float) -> void:
	pass # Replace with function body.


func _on_host_game_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2) # Attempts to create server with exported port and 2 players. Returns 'OK' if success but can be checked as bool.
	if error:
		print("Cannot host:" + error)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) # Recommended compression (from a video)
	
	multiplayer.set_multiplayer_peer(peer) # Bascially sets peer variable - the server - as a peer on multiplayer. This makes it hosted from whoever clicks the button.
	print("Waiting for players...")
	
	send_player_information($BGPanel/NameInput.text, multiplayer.get_unique_id()) # Should be 1 as host.


@rpc("any_peer", "call_local") # We do this so the GameManager data is updated for both clients
func save_unique_id(id: int):
	GameManager.save_unique_id(id)


@rpc("any_peer", "call_local") # RPC makes it callable from all peers
func start_game_rpc():
	game.start_game()


@rpc("any_peer")
func send_player_information(player_name: String, id: int):
	if not GameManager.players.has(id):
		current_players += 1
		GameManager.players[id] = {
			"player_name": player_name,
			"id": id,
			"player_num": ("player_" + var_to_str(current_players)) }
			
	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_information.rpc(GameManager.players[i].player_name, i)


func _on_join_game_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) # Must be same compression so we use range coder
	multiplayer.set_multiplayer_peer(peer)


func _on_start_game_pressed() -> void:
	start_game_rpc.rpc() # .rpc() will call it on all peers, but .rpc_id() sends it on a specific peer (e.g. 1 for host).


# Called on server and clients when a player connects
func peer_connected(id: int) -> void:
	print("Player connected with ID: " + var_to_str(id))
	save_unique_id.rpc(multiplayer.get_unique_id())


# Called on server and clients when player disconnects
func peer_disconnected(id: int) -> void:
	print("Player with ID of " + var_to_str(id) + "disconnected.")


# Called only for clients when connected
func connected_to_server() -> void:
	print("Server connected")
	send_player_information.rpc_id(1, $BGPanel/NameInput.text, multiplayer.get_unique_id()) # Calls for only host (id = 1)


# Called only for clients when failing to connect
func connection_failed() -> void:
	print("CONNECTION FAILED :(")
