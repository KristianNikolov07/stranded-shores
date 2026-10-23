extends PanelContainer

const Component := preload("res://addons/licenses/component.gd")
const Licenses := preload("res://addons/licenses/licenses.gd")
const LicenseContainer := preload("res://Scripts/Menu/Licenses/license_container.gd")

@export var _item_list: ItemList
@export var credits_menu : Control

## Container to display the license details.
@export var _license_container: LicenseContainer

func _ready() -> void:
	hide()
	# load licenses
	var res: Licenses.LoadResult = Licenses.load(Licenses.get_license_data_filepath())
	if res.err_msg != "":
		return
	var components: Array[Component] = res.components
	# add engine licenses
	components.append_array(Licenses.get_required_engine_components())
	# sort licenses by category and name ascending
	# if you want the engine license in front of all other, append them in front after sorting
	components.sort_custom(Licenses.new().compare_components_ascending)
	populate_item_list(components)


func populate_item_list(components: Array[Component]) -> void:
	# if an item in the item list is selected, set the license container's component to the selected component
	self._item_list.item_selected.connect(self._on_item_list_selected)

	# add each component to the item list
	for component: Component in components:
		self._item_list.add_item(component.name)
		self._item_list.set_item_metadata(self._item_list.item_count - 1, component)


func _on_item_list_selected(idx: int) -> void: 
	self._license_container.set_component(self._item_list.get_item_metadata(idx))


func _on_back_pressed() -> void:
	hide()
	credits_menu.show()
