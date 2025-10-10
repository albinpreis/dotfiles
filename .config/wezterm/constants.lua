local wezterm = require 'wezterm'
local M = {}

local config_dir = wezterm.config_dir

-- Normalize path separators to forward slashes
config_dir = config_dir:gsub("\\", "/")

M.bg_blurred = config_dir .. "/assets/blurred"
M.bg_image = M.bg_blurred

return M
