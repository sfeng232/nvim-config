-- ~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm';
return {
  font_size = 17.0,
  -- ctrl+- and ctrl+= to change
  -- ctrl+0 to reset
  --
  font = wezterm.font("Fantasque Sans Mono", {weight="Regular"}),
  -- color_scheme = "Solarized Dark - Patched",
  -- color_scheme = "Batman",
  line_height = 1.3,
  hide_tab_bar_if_only_one_tab = true,
  use_ime = false,

  -- WhenFollowedBySpace (default), Never, Always
  -- allow_square_glyphs_to_overflow_width = "Never",
}
