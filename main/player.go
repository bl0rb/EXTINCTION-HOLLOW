components {
  id: "player"
  component: "/main/player.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "tile_set: \"/main/player.atlas\"\n"
  "default_animation: \"player\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
}
