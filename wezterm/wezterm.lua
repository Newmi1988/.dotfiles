local wezterm = require('wezterm')

return {
    enable_tab_bar = false,
    window_decorations = "RESIZE",
    color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
    skip_close_confirmation_for_processes_named = {
        'bash',
        'sh',
        'zsh',
        'tmux',
        'nu',
        'zellij'
    },
    keys = {
        {
            key = 'q',
            mods = 'CMD',
            action = wezterm.action.CloseCurrentPane { confirm = true },
        },
    },
}
