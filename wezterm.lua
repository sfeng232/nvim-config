-- ~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm';
return {
  font_size = 13.0,
  font = wezterm.font("Fantasque Sans Mono", {weight="Regular"}),
  -- color_scheme = "Solarized Dark - Patched",
  -- color_scheme = "Batman",
  line_height = 1.2,
  hide_tab_bar_if_only_one_tab = true,
}
