class_name Talents
## Level and skill tree (GAME_SPEC §150): every level brings a talent point for an active skill or a passive trait.
## Skills sit on the keys 1-4; deeper tiers open up at higher levels, and every talent grows from one before it.

const DEFS := {
	"sweep": {"name": "Tail Sweep", "info": "hits everything around you", "tier": 0, "stamina": 15.0, "cooldown": 3.0},
	"teeth": {"name": "Sharp Teeth", "info": "+10% damage", "tier": 0},
	"hide": {"name": "Thick Hide", "info": "-4% damage taken", "tier": 0},
	"roar": {"name": "Roar", "info": "scares everything nearby away", "tier": 1, "stamina": 25.0, "cooldown": 12.0, "needs": ["hide"]},
	"charge": {"name": "Charge", "info": "rams through all in its way", "tier": 1, "stamina": 30.0, "cooldown": 6.0, "needs": ["sweep"]},
	"instinct": {"name": "Instinct", "info": "+3% critical hits", "tier": 1, "needs": ["teeth"]},
	"frenzy": {"name": "Frenzy", "info": "fast bites that heal", "tier": 2, "stamina": 20.0, "cooldown": 18.0, "needs": ["charge", "instinct"]},
	"vigor": {"name": "Vigor", "info": "+20% stamina, cheaper skills", "tier": 2, "needs": ["roar"]},
}
const SKILLS := ["sweep", "roar", "charge", "frenzy"] ## on the keys 1-4
const TIER_LEVEL := [1, 3, 6] ## level needed for each tier
const MAX_RANK := 5
const MAX_LEVEL := 30


## A talent opens once one of the talents it grows from has been learned (the threads of the tree).
static func rooted(id: String, ranks: Dictionary) -> bool:
	var needs: Array = DEFS[id].get("needs", [])
	return needs.is_empty() or needs.any(func(parent: String) -> bool: return ranks.get(parent, 0) > 0)


## Total XP needed to reach a level.
static func xp_for(level: int) -> int:
	return roundi(12.0 * pow(level - 1, 1.6))


static func level_for(xp: int) -> int:
	var level := 1
	while level < MAX_LEVEL and xp >= xp_for(level + 1):
		level += 1
	return level
