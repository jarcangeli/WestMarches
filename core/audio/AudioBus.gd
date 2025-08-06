extends Node

enum Buses {
	Master,
	Ambient
}

signal play(stream)
signal mute(bus, toggle)

const object_interact = preload("res://assets/sounds/PlasticPiece_on_CardBoard_8.wav")
const button_press = preload("res://assets/sounds/menu-button-click-30.mp3")
