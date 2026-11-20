extends Camera2D

@export var target_path : NodePath
@export var follow_lerp: float = 12.0
@export var aim_lead: float = 0.16
@export var aim_lead_max:float = 56
@export var aim_lead_lerp: float = 6.0

var _target = Node2D
var lead = Vector2.ZERO

func _ready() -> void:
	make_current()
	if target_path:
		_target = get_node_or_null(target_path)
	
	if _target and is_instance_valid(_target):
		global_position = _target.global_position

func _process(delta: float) -> void:
	if _target and is_instance_valid(_target):
		var want_lead:= Vector2.ZERO
		if aim_lead > 0.0:
			want_lead = ((get_global_mouse_position() - _target.global_position) * aim_lead).limit_length(aim_lead_max)
		lead = lead.lerp(want_lead, 1.0 - exp(-aim_lead_lerp * delta))
		
		var goal = _target.global_position + lead
		global_position = global_position.lerp(goal, 1.0 - exp(-follow_lerp * delta))
