local wezterm = require('wezterm')

local function update(first_table, second_table)
    for k, v in pairs(second_table) do
        first_table[k] = v
    end
    return first_table
end

local config = {}

local appereance = {
    enable_tab_bar = false,
    window_decorations = "RESIZE",
    window_background_opacity = 0.9375,
    color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
    line_height = 0.9,
    ---- Cursor Style Options
    -- SteadyBlock
    -- BlinkingBlock
    -- SteadyUnderline
    -- BlinkingUnderline
    -- SteadyBar
    -- BlinkingBar
    default_cursor_style = 'SteadyUnderline'
}

local keys = {
    {
        key = 'q',
        mods = 'CMD',
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },
}

local behaviour = {
    skip_close_confirmation_for_processes_named = {
        'bash',
        'sh',
        'zsh',
        'tmux',
        'nu',
        'zellij'
    },
    send_composed_key_when_left_alt_is_pressed = true,
    send_composed_key_when_right_alt_is_pressed = true,
    disable_default_key_bindings = true
}

config = update(config,appereance)
config = update(config,behaviour)
config.keys = keys

return config
