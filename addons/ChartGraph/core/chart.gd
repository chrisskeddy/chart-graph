tool
extends ReferenceRect
class_name CGChart

enum LABELS_TO_SHOW {
	NO_LABEL = 0,
	X_LABEL = 1,
	Y_LABEL = 2,
	LEGEND_LABEL = 4
}
enum CHART_TYPE {
	LINE_CHART,
	PIE_CHART
}
# Utilitary functions
const ordinary_factor = 10
const range_factor = 1000
const units = ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']

var current_show_label = LABELS_TO_SHOW.NO_LABEL
var current_data = []
var tween_node = Tween.new()
export(int, 6, 24) var MAX_VALUES = 12
onready var global_scale = Vector2(1.0, 1.0) / sqrt(MAX_VALUES)
onready var min_x = 0.0
onready var max_x = get_size().x

onready var min_y = 0.0
onready var max_y = get_size().y

func _ready():
	add_child(tween_node)
	tween_node.set_active(true)
	tween_node.start()


#func initialize(show_label, points_color = {}, animation_duration = 1.0):
#	set_labels(show_label)
#	current_animation_duration = animation_duration
#	for key in points_color:
#		current_point_color[key] = {
#			dot = points_color[key],
#			line = Color(
#				points_color[key].r,
#				points_color[key].g,
#				points_color[key].b,
#				points_color[key].a * COLOR_LINE_RATIO)
#		}


func clean_chart():
	# If there is too many points, remove old ones
	while current_data.size() > MAX_VALUES:
		var point_to_remove = current_data[0]

		if point_to_remove.has('sprites'):
			for key in point_to_remove.sprites:
				var sprite = point_to_remove.sprites[key]

				sprite.sprite.queue_free()

		current_data.remove(0)
		_update_scale()

func _update_scale():
#	current_data_size = current_data.size()
	global_scale = Vector2(1.0, 1.0) / sqrt(min(5, current_data.size()))

func _stop_tween():
#	Reset current tween
	tween_node.remove_all()
	tween_node.stop_all()

#Use for formating numbers ex 1000 becomes 1k
func format(number, format_text_custom = '%.2f %s'):
	var unit_index = 0
	var format_text = '%d %s'
	var ratio = 1

	for index in range(0, units.size()):
		var computed_ratio = pow(range_factor, index)
		if abs(number) > computed_ratio:
			ratio = computed_ratio
			unit_index = index
			if index > 0:
				format_text = format_text_custom
	return format_text % [(number / ratio), units[unit_index]]
