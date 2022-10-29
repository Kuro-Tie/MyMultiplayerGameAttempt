extends Control


var p1hp = 200
var p2hp = 200

func _ready():
	$Health1.text = str(p1hp)
	$Health2.text = str(p2hp)

func _on_Hit_pressed():
	if is_network_master():
		rpc("HitofOne")
	else:
		rpc("HitofTwo")


func _on_Heal_pressed():
	if is_network_master():
		rpc("HealofOne")
	else:
		rpc("HealofTwo")


remotesync func HitofOne():
	p2hp = p2hp - 50
	$Health2.text = str(p2hp)

remotesync func HitofTwo():
	p1hp = p1hp - 50
	$Health1.text = str(p1hp)

remotesync func HealofOne():
	p1hp = p1hp + 50
	$Health1.text = str(p1hp)

remotesync func HealofTwo():
	p2hp = p2hp + 50
	$Health2.text = str(p2hp)
