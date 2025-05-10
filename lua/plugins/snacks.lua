return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    explorer = { enabled = true },
    image = { enabled = false }, -- Enable when using Kitty or Ghosty as Terminal
    input = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    terminal = { enabled = true },
    words = { enabled = true },
    indent = {
      enabled = true,
      animate = {
        enabled = false,
      },
    },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          actions = {
            -- Provide multiple copy options for the filename under the cursor
            copy_file_path = {
              action = function(_, item)
                if not item then
                  return
                end

                local vals = {
                  ["BASENAME"] = vim.fn.fnamemodify(item.file, ":t:r"),
                  ["EXTENSION"] = vim.fn.fnamemodify(item.file, ":t:e"),
                  ["FILENAME"] = vim.fn.fnamemodify(item.file, ":t"),
                  ["PATH"] = item.file,
                  ["PATH (CWD)"] = vim.fn.fnamemodify(item.file, ":."),
                  ["PATH (HOME)"] = vim.fn.fnamemodify(item.file, ":~"),
                  ["URI"] = vim.uri_from_fname(item.file),
                }

                local options = vim.tbl_filter(function(val)
                  return vals[val] ~= ""
                end, vim.tbl_keys(vals))
                if vim.tbl_isempty(options) then
                  vim.notify("No values to copy", vim.log.levels.WARN)
                  return
                end
                table.sort(options)
                vim.ui.select(options, {
                  prompt = "Choose to copy to clipboard:",
                  format_item = function(list_item)
                    return ("%s: %s"):format(list_item, vals[list_item])
                  end,
                }, function(choice)
                  local result = vals[choice]
                  if result then
                    vim.fn.setreg("+", result)
                    Snacks.notify.info("Yanked `" .. result .. "`")
                  end
                end)
              end,
            },
            -- Search within all files from the selected directory
            search_in_directory = {
              action = function(_, item)
                if not item then
                  return
                end
                local dir = vim.fn.fnamemodify(item.file, ":p:h")
                Snacks.picker.grep({
                  cwd = dir,
                  cmd = "rg",
                  args = {
                    "-g",
                    "!.git",
                    "-g",
                    "!node_modules",
                    "-g",
                    "!dist",
                    "-g",
                    "!build",
                    "-g",
                    "!coverage",
                    "-g",
                    "!.DS_Store",
                    "-g",
                    "!.docusaurus",
                    "-g",
                    "!.dart_tool",
                  },
                  show_empty = true,
                  hidden = true,
                  ignored = true,
                  follow = false,
                  supports_live = true,
                })
              end,
            },
            -- Compare two selected files
            -- The files can be selected with Tab or Shift+Tab
            diff = {
              action = function(picker)
                picker:close()
                local sel = picker:selected()
                if #sel > 0 and sel then
                  Snacks.notify.info(sel[1].file)
                  vim.cmd("tabnew " .. sel[1].file)
                  vim.cmd("vert diffs " .. sel[2].file)
                  Snacks.notify.info("Diffing " .. sel[1].file .. " against " .. sel[2].file)
                  return
                end

                Snacks.notify.info("Select two entries for the diff")
              end,
            },
          },
          -- Keybindings for the explorer actions
          win = {
            list = {
              keys = {
                ["y"] = "copy_file_path",
                ["s"] = "search_in_directory",
                ["D"] = "diff",
              },
            },
          },
        },
      },
    },
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function() return Snacks.git.get_root() ~= nil end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = 'startup' },
      },
    },
  },
  keys = {
    -- Top Pickers & Explorer
    { '<leader><space>', function() Snacks.picker.smart() end,                                 desc = 'Smart Find Files' },
    { '<leader>,',       function() Snacks.picker.buffers() end,                               desc = 'Buffers' },
    { '<leader>/',       function() Snacks.picker.grep() end,                                  desc = 'Grep' },
    { '<leader>:',       function() Snacks.picker.command_history() end,                       desc = 'Command History' },
    { '<leader>n',       function() Snacks.picker.notifications() end,                         desc = 'Notification History' },
    { '<leader>e',       function() Snacks.explorer() end,                                     desc = 'File Explorer' },
    -- find
    { '<leader>fb',      function() Snacks.picker.buffers() end,                               desc = 'Buffers' },
    { '<leader>fc',      function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File' },
    { '<leader>ff',      function() Snacks.picker.files() end,                                 desc = 'Find Files' },
    { '<leader>fg',      function() Snacks.picker.git_files() end,                             desc = 'Find Git Files' },
    { '<leader>fp',      function() Snacks.picker.projects() end,                              desc = 'Projects' },
    { '<leader>fr',      function() Snacks.picker.recent() end,                                desc = 'Recent' },
    -- git
    { '<leader>gb',      function() Snacks.picker.git_branches() end,                          desc = 'Git Branches' },
    { '<leader>gl',      function() Snacks.picker.git_log() end,                               desc = 'Git Log' },
    { '<leader>gL',      function() Snacks.picker.git_log_line() end,                          desc = 'Git Log Line' },
    { '<leader>gs',      function() Snacks.picker.git_status() end,                            desc = 'Git Status' },
    { '<leader>gS',      function() Snacks.picker.git_stash() end,                             desc = 'Git Stash' },
    { '<leader>gd',      function() Snacks.picker.git_diff() end,                              desc = 'Git Diff (Hunks)' },
    { '<leader>gf',      function() Snacks.picker.git_log_file() end,                          desc = 'Git Log File' },
    -- Grep
    { '<leader>sb',      function() Snacks.picker.lines() end,                                 desc = 'Buffer Lines' },
    { '<leader>sB',      function() Snacks.picker.grep_buffers() end,                          desc = 'Grep Open Buffers' },
    { '<leader>sg',      function() Snacks.picker.grep() end,                                  desc = 'Grep' },
    { '<leader>sw',      function() Snacks.picker.grep_word() end,                             desc = 'Visual selection or word',        mode = { 'n', 'x' } },
    -- search
    { '<leader>s"',      function() Snacks.picker.registers() end,                             desc = 'Registers' },
    { '<leader>s/',      function() Snacks.picker.search_history() end,                        desc = 'Search History' },
    { '<leader>sa',      function() Snacks.picker.autocmds() end,                              desc = 'Autocmds' },
    { '<leader>sb',      function() Snacks.picker.lines() end,                                 desc = 'Buffer Lines' },
    { '<leader>sc',      function() Snacks.picker.command_history() end,                       desc = 'Command History' },
    { '<leader>sC',      function() Snacks.picker.commands() end,                              desc = 'Commands' },
    { '<leader>sd',      function() Snacks.picker.diagnostics() end,                           desc = 'Diagnostics' },
    { '<leader>sD',      function() Snacks.picker.diagnostics_buffer() end,                    desc = 'Buffer Diagnostics' },
    { '<leader>sh',      function() Snacks.picker.help() end,                                  desc = 'Help Pages' },
    { '<leader>sH',      function() Snacks.picker.highlights() end,                            desc = 'Highlights' },
    { '<leader>si',      function() Snacks.picker.icons() end,                                 desc = 'Icons' },
    { '<leader>sj',      function() Snacks.picker.jumps() end,                                 desc = 'Jumps' },
    { '<leader>sk',      function() Snacks.picker.keymaps() end,                               desc = 'Keymaps' },
    { '<leader>sl',      function() Snacks.picker.loclist() end,                               desc = 'Location List' },
    { '<leader>sm',      function() Snacks.picker.marks() end,                                 desc = 'Marks' },
    { '<leader>sM',      function() Snacks.picker.man() end,                                   desc = 'Man Pages' },
    { '<leader>sp',      function() Snacks.picker.lazy() end,                                  desc = 'Search for Plugin Spec' },
    { '<leader>sq',      function() Snacks.picker.qflist() end,                                desc = 'Quickfix List' },
    { '<leader>sR',      function() Snacks.picker.resume() end,                                desc = 'Resume' },
    { '<leader>su',      function() Snacks.picker.undo() end,                                  desc = 'Undo History' },
    { '<leader>uC',      function() Snacks.picker.colorschemes() end,                          desc = 'Colorschemes' },
    -- LSP
    { 'gd',              function() Snacks.picker.lsp_definitions() end,                       desc = 'Goto Definition' },
    { 'gD',              function() Snacks.picker.lsp_declarations() end,                      desc = 'Goto Declaration' },
    { 'gr',              function() Snacks.picker.lsp_references() end,                        nowait = true,                            desc = 'References' },
    { 'gI',              function() Snacks.picker.lsp_implementations() end,                   desc = 'Goto Implementation' },
    { 'gy',              function() Snacks.picker.lsp_type_definitions() end,                  desc = 'Goto T[y]pe Definition' },
    { '<leader>ss',      function() Snacks.picker.lsp_symbols() end,                           desc = 'LSP Symbols' },
    { '<leader>sS',      function() Snacks.picker.lsp_workspace_symbols() end,                 desc = 'LSP Workspace Symbols' },
    -- Other
    { '<leader>dB',      function() Snacks.bufdelete() end,                                    desc = 'Delete or Close Buffer (Confirm)' },
    { '<c-/>',           function() Snacks.terminal() end,                                     desc = 'Toggle Terminal' },
    { '<c-_>',           function() Snacks.terminal() end,                                     desc = 'which_key_ignore' },
  },
}
