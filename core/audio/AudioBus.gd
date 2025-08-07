extends Node

enum Buses {
	Master,
	Ambient
}

signal play(stream)
signal mute(bus, toggle)

const object_interact = preload("res://assets/sounds/ui-mechanical-button-click-gfx-sounds-1-1-00-00.mp3")
const button_press = preload("res://assets/sounds/ui-mechanical-button-click-gfx-sounds-1-1-00-00.mp3")
