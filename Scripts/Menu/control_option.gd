extends HBoxContainer

@export var action : String
@export var key : InputEvent
@export var controller_key : InputEvent

var is_rebinding = false
var is_controller = false

@onready var controls_menu = get_tree().current_scene.find_child("ControlsMenu")

func _ready() -> void:
	$Label.text = action
	update_buttons()


func _input(event: InputEvent) -> void:
	if is_rebinding:
		if event.is_pressed():
			if is_controller == false and (event is InputEventMouse or event is InputEventKey):
				key = event
				controls_menu.set_key(action, event)
			elif is_controller and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
				controller_key = event
				controls_menu.set_key(action, event, true)
			update_buttons()
			is_rebinding = false
			accept_event()


func _on_rebind_button_pressed() -> void:
	is_rebinding = true
	is_controller = false
	%RebindButton.text = "< " + %RebindButton.text + " >"
	%RebindButton.button_pressed = true


func _on_controller_rebind_button_pressed() -> void:
	is_rebinding = true
	is_controller = true
	%ControllerRebindButton.text = "< " + %ControllerRebindButton.text + " >"
	%ControllerRebindButton.button_pressed = true


func update_buttons() -> void:
	%RebindButton.text = key.as_text().replace("(Physical)", "").lstrip(" ").rstrip(" ")
	if key.as_text() == "Left Mouse Button":
		%RebindButton.text = "LBM"
	elif key.as_text() == "Right Mouse Button":
		%RebindButton.text = "RBM"
	%RebindButton.button_pressed = false
	%ControllerRebindButton.button_pressed = false
	if controller_key != null:
		var regex := RegEx.new()
		regex.compile("(?<=\\()[^,]+")
		var result := regex.search(controller_key.as_text())
		%ControllerRebindButton.text = result.get_string()
	else:
		%ControllerRebindButton.hide()
