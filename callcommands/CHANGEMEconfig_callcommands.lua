--[[
    snaily Plugins

    Plugin Configuration

    Put all needed configuration in this file.
]]
local config = {
    enabled = true,
    pluginName = "callcommands", -- name your plugin here
    pluginAuthor = "snailyCAD", -- author
    requiresPlugins = {"locations"}, -- required plugins for this plugin to work, separated by commas

    -- put your configuration options below
    enable911 = true
}

if config.enabled then
    Config.RegisterPluginConfig(config.pluginName, config)
end