components {
  id: "cave"
  component: "/main/cave.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "tile_set: \"/main/cave.atlas\"\n"
  "default_animation: \"cave\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
}
