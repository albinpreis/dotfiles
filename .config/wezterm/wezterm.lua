local wezterm = require 'wezterm'
local constants = require 'constants'
local config = {}

-- In older WezTerm versions, use this format
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_background_image = constants.bg_image
config.window_background_image_hsb = {
    brightness = 0.1,
    hue = 1.0,
    saturation = 1.0,
}
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.mouse_bindings = {
    {
        event = { Drag = { streak = 1, button = 'Left' } },
        mods = 'CTRL|SHIFT',
        action = wezterm.action.StartWindowDrag,
    },
}

config.max_fps = 120
config.prefer_egl = true

-- Set WSL as default
config.default_domain = 'WSL:Ubuntu-24.04'

return config
