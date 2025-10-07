local wezterm = require 'wezterm'
local M = {}

local config_dir = wezterm.config_dir

M.bg_blurred = config_dir .. "/assets/blurred"
M.bg_image = M.bg_blurred

return M
