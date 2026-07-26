extends Control

@onready var resolution_dropbox: = get_node("%resolution_dropbox")
@onready var window_mode_dropbox: = get_node("%window_mode_dropbox")
@onready var volume_master_slider: = %volume_master_slider
@onready var volume_music_slider: = %volume_music_slider
@onready var volume_sfx_slider: = %volume_sfx_slider
@onready var mute_checkbox:CheckBox = %mute_checkbox
@onready var keybinding_list: = get_node("%keybinding_list")

@onready var video_label: = get_node("%video_label")
@onready var video_tab: = get_node("%video_tab")

@onready var audio_label: = get_node("%audio_label")
@onready var audio_tab: = get_node("%audio_tab")

@onready var controls_label: = get_node("%controls_label")
@onready var controls_tab: = get_node("%controls_tab")


func _ready() -> void:
	Config_Handler.window_mode_changed.connect(_on_window_mode_changed)
	var window_mode : Variant = Config_Handler.get_setting("video", "window_mode")
	var window_resolution := [Config_Handler.get_setting("video", "width"), Config_Handler.get_setting("video", "height")]
	window_mode_dropbox.select(window_mode_dropbox.get_item_index(window_mode))
	resolution_dropbox.select_item(window_resolution)
	volume_master_slider.value = min(Config_Handler.get_setting("audio", "master_volume"), 1.0) * 100
	volume_music_slider.value = min(Config_Handler.get_setting("audio", "music_volume"), 1.0) * 100
	volume_sfx_slider.value = min(Config_Handler.get_setting("audio", "sfx_volume"), 1.0) * 100
	mute_checkbox.button_pressed = Config_Handler.get_setting("audio", "mute")
	

func _on_window_mode_changed(value: int) -> void:
	window_mode_dropbox.select(window_mode_dropbox.get_item_index(value))

func _on_window_mode_dropbox_item_selected(index: int) -> void:
	Config_Handler.change_window_settings(window_mode_dropbox.get_item_id(index), null)
	

func _on_resolution_dropbox_item_selected(index: int) -> void:
	Config_Handler.change_window_settings(null, resolution_dropbox.get_selected_item(index))
	

func _on_volume_master_slider_value_changed(value: float) -> void:
	mute_checkbox.button_pressed = false
	AudioManager.play_global("ui.slider.tick")
	Config_Handler.change_master_volume(value)
	

func _on_volume_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Config_Handler.save_audio_settings("master_volume", volume_master_slider.value / 100)
	

func _on_volume_music_slider_value_changed(value: float) -> void:
	AudioManager.play_global("ui.slider.tick")
	Config_Handler.change_music_volume(value)


func _on_volume_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Config_Handler.save_audio_settings("music_volume", volume_music_slider.value / 100)
		

func _on_volume_sfx_slider_value_changed(value:float) -> void:
	AudioManager.play_global("ui.slider.tick")
	Config_Handler.change_sfx_volume(value)
	

func _on_volume_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Config_Handler.save_audio_settings("sfx_volume", volume_sfx_slider.value / 100)
	

func _on_mute_checkbox_toggled(toggled_on: bool) -> void:
	AudioManager.play_global("ui.button.click")
	Config_Handler.save_audio_settings("mute", toggled_on)
	Config_Handler.toggle_mute(toggled_on)
	

func _on_back_button_pressed() -> void:
	AudioManager.play_global("ui.screen.back")
	UI_Controller.freeScreen()
	


func _on_video_label_gui_input(event:InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed):
		video_label.label_settings.font_color = Color(0.94, 0.896, 0.405, 1.0)
		audio_label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		controls_label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		video_tab.visible = true
		audio_tab.visible = false
		controls_tab.visible = false


func _on_audio_label_gui_input(event:InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed):
		video_label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		audio_label.label_settings.font_color = Color(0.94, 0.896, 0.405, 1.0)
		controls_label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		video_tab.visible = false
		audio_tab.visible = true
		controls_tab.visible = false


func _on_controls_label_gui_input(event:InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed):
		video_label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		audio_label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		controls_label.label_settings.font_color = Color(0.94, 0.896, 0.405, 1.0)
		video_tab.visible = false
		audio_tab.visible = false
		controls_tab.visible = true


func _on_texture_button_pressed() -> void:
	UI_Controller.freeScreen()
