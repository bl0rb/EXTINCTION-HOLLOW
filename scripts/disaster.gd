class_name Disaster
extends Resource
## Data for one disaster type (GAME_SPEC §58).

@export var type := &"earthquake"
@export var warning_text := ""
@export var warning_time := 4.0 ## seconds between the warning and the disaster
@export var duration := 6.0
@export var intensity := 1.0
@export var damage := 20.0 ## per hit (falling rock, lava bomb)
@export var radius := 700.0 ## animals this close to the source panic
@export var weight := 1.0 ## how often it is picked
