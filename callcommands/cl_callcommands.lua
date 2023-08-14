--[[
    Sonaran CAD Plugins

    Plugin Name: callcommands
    Creator: SonoranCAD
    Description: Implements 311/511/911 commands
]]
local pluginConfig = Config.GetPluginConfig("callcommands")

if pluginConfig.enabled then
---------------------------------------------------------------------------
-- Chat Suggestions **DO NOT EDIT UNLESS YOU KNOW WHAT YOU ARE DOING**
---------------------------------------------------------------------------
    CreateThread(function()
        if Config.enable911 then
            TriggerEvent('chat:addSuggestion', '/911', 'Sends a emergency call to your SonoranCAD', {
                { name="Description of Call", help="State what the call is about" }
            })
        end

    end)
end