class_name Talents
## Level and skill tree (GAME_SPEC §150): every level brings a talent point for an active skill or a passive trait.
## Skills sit on the keys 1-4; deeper tiers open up at higher levels.

const DEFS := {
	"sweep": {"name": "Tail Sweep", "info": "hits everything around you", "tier": 0, "stamina": 15.0, "cooldown": 3.0},
	"teeth": {"name": "Sharp Teeth", "info": "+10% damage", "tier": 0},
	"hide": {"name": "Thick Hide", "info": "-4% damage taken", "tier": 0},
	"roar": {"name": "Roar", "info": "scares everything nearby away", "tier": 1, "stamina": 25.0, "cooldown": 12.0},
	"charge": {"name": "Charge", "info": "rams through all in its way", "tier": 1, "stamina": 30.0, "cooldown": 6.0},
	"instinct": {"name": "Instinct", "info": "+3% critical hits", "tier": 1},
	"frenzy": {"name": "Frenzy", "info": "fast bites that heal", "tier": 2, "stamina": 20.0, "cooldown": 18.0},
	"vigor": {"name": "Vigor", "info": "+20% stamina, cheaper skills", "tier": 2},
}
const SKILLS := ["sweep", "roar", "charge", "frenzy"] ## on the keys 1-4
const TIER_LEVEL := [1, 3, 6] ## level needed for each tier
const MAX_RANK := 5
const MAX_LEVEL := 30


## Total XP needed to reach a level.
static func xp_for(level: int) -> int:
	return roundi(12.0 * pow(level - 1, 1.6))


static func level_for(xp: int) -> int:
	var level := 1
	while level < MAX_LEVEL and xp >= xp_for(level + 1):
		level += 1
	return level
