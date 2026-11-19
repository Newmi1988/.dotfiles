-- tmux-compatible session, tab, and pane controls.
rex.bind("ctrl+b>s", "session.switch")
rex.bind("ctrl+b>w", "session.switch")
rex.bind("ctrl+b>r", "session.rename")
rex.bind("ctrl+b>shift+4", "session.rename")
rex.bind("ctrl+b>alt+4", "session.rename")
rex.bind("ctrl+b>alt+j", "session.previous")
rex.bind("ctrl+b>alt+e", "session.previous")
rex.bind("ctrl+b>shift+8", "session.previous")
rex.bind("ctrl+b>[", "session.previous")
rex.bind("ctrl+b>alt+k", "session.next")
rex.bind("ctrl+b>alt+r", "session.next")
rex.bind("ctrl+b>shift+9", "session.next")
rex.bind("ctrl+b>]", "session.next")

rex.bind("ctrl+b>c", "client.tab.new")
rex.bind("ctrl+b>n", "client.tab.next")
rex.bind("ctrl+b>p", "client.tab.previous")
rex.bind("ctrl+b>,", "client.tab.rename")
rex.bind("ctrl+b>shift+r", "client.tab.rename")
rex.bind("ctrl+b>alt+p", "client.tab.close")
rex.bind("ctrl+b>shift+6", "client.tab.close")
rex.bind("ctrl+b>q", "client.tab.close")
rex.bind("ctrl+b>shift+k", "client.tab.close")

rex.bind("ctrl+b>v", "pane.split", { direction = "right" })
rex.bind("ctrl+b>alt+m", "pane.split", { direction = "right" })
rex.bind("ctrl+b>alt+c", "pane.split", { direction = "right" })
rex.bind("ctrl+b>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+b>alt+7", "pane.split", { direction = "right" })
rex.bind("ctrl+b>shift+\\", "pane.split", { direction = "right" })
rex.bind("ctrl+b>d", "pane.split", { direction = "down" })
rex.bind("ctrl+b>alt+,", "pane.split", { direction = "down" })
rex.bind("ctrl+b>alt+l", "pane.split", { direction = "down" })
rex.bind("ctrl+b>shift+2", "pane.split", { direction = "down" })
rex.bind("ctrl+b>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+b>-", "pane.split", { direction = "down" })

rex.bind("ctrl+b>z", "pane.zoom")
rex.bind("ctrl+b>x", "pane.close")
rex.bind("ctrl+b>space", "pane.balance")

rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })

rex.action{
  name = "opencode_split",
  title = "OpenCode Split",
  run = function(ctx, args)
    local home = os.getenv("HOME") or "/Users/newmi"
    local rex_dir = os.getenv("REX_BIN_DIR") or (home .. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS")
    local rex_bin = rex_dir .. "/rex"
    local opencode_bin = "/opt/homebrew/bin/opencode"

    -- Find the active pane's current working directory.
    local target_cwd = nil
    if ctx.session_id and ctx.block_id then
      local proc, _ = rex.call("block.method", {
        session_id = ctx.session_id,
        block_id = ctx.block_id,
        method = "process",
      })
      if proc then
        if proc.foreground and proc.foreground.cwd and proc.foreground.cwd ~= "" then
          target_cwd = proc.foreground.cwd
        end
        if not target_cwd and proc.ancestors then
          for _, a in ipairs(proc.ancestors) do
            if a.cwd and a.cwd ~= "" then
              target_cwd = a.cwd
              break
            end
          end
        end
        if not target_cwd and proc.child and proc.child.cwd and proc.child.cwd ~= "" then
          target_cwd = proc.child.cwd
        end
      end
    end
    if not target_cwd then
      target_cwd = home
    end

    local path = table.concat({
      "/opt/homebrew/bin",
      "/opt/homebrew/sbin",
      home .. "/.local/bin",
      rex_dir,
      "/usr/local/bin",
      "/usr/bin",
      "/bin",
      "/usr/sbin",
      "/sbin",
    }, ":")

    local cmd = {
      rex_bin, "split",
      "--split=right",
      "--ratio=33",
      "-c", target_cwd,
    }
    if ctx.session_id then
      table.insert(cmd, "-s")
      table.insert(cmd, ctx.session_id)
    end
    if ctx.block_id then
      table.insert(cmd, "-b")
      table.insert(cmd, ctx.block_id)
    end
    table.insert(cmd, "--")
    table.insert(cmd, "sh")
    table.insert(cmd, "-c")
    table.insert(cmd, string.format(
      'cd "%s" && if [ "$("%s" session list -n 1 --format json 2>/dev/null)" != "[]" ]; then exec "%s" -c; else exec "%s"; fi',
      target_cwd, opencode_bin, opencode_bin, opencode_bin
    ))

    local r, err = rex.exec(cmd, {
      cwd = target_cwd,
      env = {
        PATH = path,
        HOME = home,
      },
    })
    if r == nil then error(err, 0) end
    if not r.ok then error(r.stderr, 0) end
  end,
}
rex.bind("ctrl+b>o", "opencode_split")

rex.action{
  name = "pi_split",
  title = "Pi Split",
  run = function(ctx, args)
    local home = os.getenv("HOME") or "/Users/newmi"
    local rex_dir = os.getenv("REX_BIN_DIR") or (home .. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS")
    local rex_bin = rex_dir .. "/rex"
    local pi_bin = home .. "/.local/bin/pi"

    -- Find the active pane's current working directory.
    local target_cwd = nil
    if ctx.session_id and ctx.block_id then
      local proc, _ = rex.call("block.method", {
        session_id = ctx.session_id,
        block_id = ctx.block_id,
        method = "process",
      })
      if proc then
        if proc.foreground and proc.foreground.cwd and proc.foreground.cwd ~= "" then
          target_cwd = proc.foreground.cwd
        end
        if not target_cwd and proc.ancestors then
          for _, a in ipairs(proc.ancestors) do
            if a.cwd and a.cwd ~= "" then
              target_cwd = a.cwd
              break
            end
          end
        end
        if not target_cwd and proc.child and proc.child.cwd and proc.child.cwd ~= "" then
          target_cwd = proc.child.cwd
        end
      end
    end
    if not target_cwd then
      target_cwd = home
    end

    local path = table.concat({
      "/opt/homebrew/bin",
      "/opt/homebrew/sbin",
      home .. "/.local/bin",
      rex_dir,
      "/usr/local/bin",
      "/usr/bin",
      "/bin",
      "/usr/sbin",
      "/sbin",
    }, ":")

    local cmd = {
      rex_bin, "split",
      "--split=right",
      "--ratio=33",
      "-c", target_cwd,
    }
    if ctx.session_id then
      table.insert(cmd, "-s")
      table.insert(cmd, ctx.session_id)
    end
    if ctx.block_id then
      table.insert(cmd, "-b")
      table.insert(cmd, ctx.block_id)
    end
    table.insert(cmd, "--")
    table.insert(cmd, "sh")
    table.insert(cmd, "-c")
    table.insert(cmd, string.format(
      'cd "%s" && exec "%s" -c',
      target_cwd, pi_bin
    ))

    local r, err = rex.exec(cmd, {
      cwd = target_cwd,
      env = {
        PATH = path,
        HOME = home,
      },
    })
    if r == nil then error(err, 0) end
    if not r.ok then error(r.stderr, 0) end
  end,
}
rex.bind("ctrl+b>i", "pi_split")

rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })
