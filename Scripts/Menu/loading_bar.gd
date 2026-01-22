extends TextureProgressBar

var scene_name : String
var progress = []

func _ready() -> void:
	load_scene("res://Scenes/Worlds/main.tscn")
	if OS.get_name() == "Web":
		value = 100


func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(scene_name, progress)
	value = floor(progress[0]*100)
	print(floor(progress[0]*100))
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var scene = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(scene)


func load_scene(_scene_name : String) -> void:
	show()
	scene_name = _scene_name
	ResourceLoader.load_threaded_request(scene_name)
