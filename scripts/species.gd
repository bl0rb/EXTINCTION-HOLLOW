class_name Species
extends Resource
## Data for one animal species (GAME_SPEC §57).

@export var xp: int
@export var size: int ## size class 1-5 (GAME_SPEC §8)
@export var food: float ## hunger restored when eaten
@export var stride: float ## pixels per walk frame
@export var acceleration: float ## pixels per second², big animals get going slowly
@export var speed: float ## wandering, pixels per second
@export var flee_speed: float ## pixels per second
@export var fear_radius: float
@export var calm_radius: float
@export var wander_radius: float
@export var idle_time: float ## average seconds between wander moves
@export var chase_speed: float ## predators, pixels per second
@export var vision_radius: float ## predators start chasing inside this distance
@export var attack_range: float ## predators bite inside this distance
@export var damage: int
@export var attack_interval: float ## seconds between bites
