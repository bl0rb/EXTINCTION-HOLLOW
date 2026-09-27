class_name Species
extends Resource
## Data for one animal species (GAME_SPEC §57).

@export var xp: int
@export var speed: float ## wandering, pixels per second
@export var flee_speed: float ## pixels per second
@export var fear_radius: float
@export var calm_radius: float
@export var wander_radius: float
@export var idle_time: float ## average seconds between wander moves
