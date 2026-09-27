components {
  id: "prey"
  component: "/main/prey.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "tile_set: \"/main/lizard.atlas\"\n"
  "default_animation: \"lizard\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
}
