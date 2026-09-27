extends NavigationRegion2D
## Walkable area for click-to-move, baked from all static obstacles at start and again when rubble has fallen.


func _ready() -> void:
	rebake.call_deferred()


func rebake() -> void:
	bake_navigation_polygon(false)
