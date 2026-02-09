extends HBoxContainer

@export var action : String
@export var key : InputEvent

var is_rebinding = false
var is_controller = false

@onready var controls_menu = get_tree().current_scene.find_child("ControlsMenu")

func _ready() -> void:
	$Label.text = action
	update_button()


func _input(event: InputEvent) -> void:
	if is_rebinding:
		if event.is_pressed():
			if is_controller == false and (event is InputEventMouse or event is InputEventKey):
				controls_menu.set_key(action, event)
			elif is_controller and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
				controls_menu.set_key(action, event, true)
			key = event
			update_button()
			is_rebinding = false
			accept_event()


func _on_rebind_button_pressed() -> void:
	is_rebinding = true
	%RebindButton.text = "< " + %RebindButton.text + " >"
	%RebindButton.button_pressed = true


func update_button() -> void:
	if is_controller == false:
		%RebindButton.text = key.as_text().replace("(Physical)", "").lstrip(" ").rstrip(" ")
		if key.as_text() == "Left Mouse Button":
			%RebindButton.text = "LBM"
		elif key.as_text() == "Right Mouse Button":
			%RebindButton.text = "RBM"
	else:
		var regex := RegEx.new()
		regex.compile("(?<=\\()[^,]+")
		var result := regex.search(key.as_text())
		%RebindButton.text = result.get_string()
	%RebindButton.button_pressed = false
			
