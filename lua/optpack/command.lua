local UpdateOption = require("optpack.core.option").UpdateOption
local InstallOption = require("optpack.core.option").InstallOption
local Plugins = require("optpack.core.plugin").Plugins
local Outputters = require("optpack.view.outputter").Outputters
local messagelib = require("optpack.lib.message")

local M = {}

local Command = {}
Command.__index = Command
M.Command = Command

function Command.new(name, ...)
  local args = vim.F.pack_len(...)
  local f = function()
    return Command[name](vim.F.unpack_len(args))
  end

  local ok, result, msg = xpcall(f, debug.traceback)
  if not ok then
    return messagelib.error(result)
  elseif msg then
    return messagelib.warn(msg)
  end
  return result
end

function Command.add(full_name, raw_opts)
  return nil, Plugins.state():add(full_name, raw_opts)
end

function Command.list()
  return Plugins.state():list()
end

function Command.update(raw_opts)
  local opts = UpdateOption.new(raw_opts)

  local outputters, err = Outputters.from(opts.output_types)
  if err then
    return nil, err
  end

  return nil, Plugins.state():update(outputters, opts.pattern, opts.parallel_limit, opts.parallel_interval, opts.on_finished)
end

function Command.install(raw_opts)
  local opts = InstallOption.new(raw_opts)

  local outputters, err = Outputters.from(opts.output_types)
  if err then
    return nil, err
  end

  return nil, Plugins.state():install(outputters, opts.pattern, opts.parallel_limit, opts.parallel_interval, opts.on_finished)
end

function Command.load(plugin_name)
  return nil, Plugins.state():load(plugin_name)
end

return M
