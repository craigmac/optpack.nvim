local OrderedDict = require("optpack.lib.ordered_dict").OrderedDict

local M = {}

local PluginCollection = {}
PluginCollection.__index = PluginCollection
M.PluginCollection = PluginCollection

function PluginCollection.new()
  local tbl = {_plugins = OrderedDict.new()}
  return setmetatable(tbl, PluginCollection)
end

function PluginCollection.collect(self, pattern)
  local raw_plugins = {}
  local regex = vim.regex(pattern)
  for _, plugin in self._plugins:iter() do
    if regex:match_str(plugin.name) then
      table.insert(raw_plugins, plugin)
    end
  end
  return raw_plugins
end

function PluginCollection.add(self, plugin)
  self._plugins[plugin.name] = plugin
end

function PluginCollection.remove(self, plugin_name)
  self._plugins[plugin_name] = nil
end

function PluginCollection.find_by_name(self, plugin_name)
  for _, plugin in self._plugins:iter() do
    if plugin.name == plugin_name then
      return plugin
    end
  end
end

function PluginCollection.expose(self)
  local values = {}
  for _, plugin in self._plugins:iter() do
    table.insert(values, plugin:expose())
  end
  return values
end

return M
