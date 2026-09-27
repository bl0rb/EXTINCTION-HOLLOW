class_name Upgrades
## Upgrade definitions (GAME_SPEC §16-§19). Banked XP is spent on the dino or the cave; each level costs more.

const PLAYER := {
	"health": {"name": "Health", "info": "+20 max health", "max": 5, "cost": 10, "cost_step": 10, "step": 20.0},
	"speed": {"name": "Speed", "info": "+8 walk, +12 sprint", "max": 5, "cost": 12, "cost_step": 10, "step": 8.0},
	"bite": {"name": "Bite", "info": "+4 bite reach", "max": 5, "cost": 8, "cost_step": 8, "step": 4.0},
	"size": {"name": "Size", "info": "+1 size class", "max": 3, "cost": 40, "cost_step": 40, "step": 1.0},
}

## Cave stats cannot exceed the cave level.
const CAVE := {
	"level": {"name": "Cave Level", "info": "bigger cave, higher limits", "max": 5, "cost": 30, "cost_step": 30},
	"strength": {"name": "Strength", "info": "sturdier walls", "cost": 10, "cost_step": 10},
	"depth": {"name": "Depth", "info": "deeper shelter", "cost": 10, "cost_step": 10},
	"heat": {"name": "Heat Resist.", "info": "fire and lava", "cost": 10, "cost_step": 10},
	"quake": {"name": "Quake Resist.", "info": "earthquakes", "cost": 10, "cost_step": 10},
	"cold": {"name": "Cold Resist.", "info": "snow and frost", "cost": 8, "cost_step": 8},
}


static func cost(def: Dictionary, bought: int) -> int:
	return def.cost + def.cost_step * bought
