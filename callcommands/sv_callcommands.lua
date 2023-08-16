--[[
    Sonaran CAD Plugins

    Plugin Name: callcommands
    Creator: snailyCAD
    Description: Implements 311/511/911 commands
]]

local pluginConfig = Config.GetPluginConfig("callcommands")

if pluginConfig.enabled then

    -- 911/311 Handler
    function HandleCivilianCall(type, source, args, rawCommand)
        local identifier = GetIdentifiers(source)[Config.primaryIdentifier]
        local callLocation = LocationCache[source] ~= nil and LocationCache[source].location or 'Unknown'
        local player = source
        local ped = GetPlayerPed(player)
        local playerCoords = GetEntityCoords(ped)
        -- Checking if there are any description arguments.
        if args[1] then
            local description = table.concat(args, " ")
            if type == "511" then
                description = "(511 CALL) "..description
            end
            local caller = nil
            if isPluginLoaded("frameworksupport") then
                -- Getting the ESX Identity Name
                GetIdentity(source, function(identity)
                    if identity.name ~= nil then
                        caller = identity.name
                    else
                        caller = GetPlayerName(source)
                        debugLog("Unable to get player name from ESX. Falled back to in-game name.")
                    end
                end)
                while caller == nil do
                    Wait(10)
                end
            else
                caller = GetPlayerName(source) 
            end
            -- Sending the API event
            TriggerEvent('snailyCAD::callcommands:SendCallApi',playerCoords, caller, callLocation, description, source)
            -- Sending the user a message stating the call has been sent
            TriggerClientEvent("chat:addMessage", source, {args = {"^0^5^*[snailyCAD]^r ", "^7Your call has been sent to dispatch. Help is on the way!"}})
        else
            -- Throwing an error message due to now call description stated
            TriggerClientEvent("chat:addMessage", source, {args = {"^0[ ^1Error ^0] ", "You need to specify a call description."}})
        end
    end

    CreateThread(function()
        if pluginConfig.enable911 then
            RegisterCommand('911', function(source, args, rawCommand)
                HandleCivilianCall("911", source, args, rawCommand)
            end, false)
        end
      

    end)

    -- Client Call request
    RegisterServerEvent('snailyCAD::callcommands:SendCallApi')
    AddEventHandler('snailyCAD::callcommands:SendCallApi', function(playerCoords, caller, location, description, source)
        -- send an event to be consumed by other resources
        local postal = nil
        if isPluginLoaded("postals") and PostalsCache ~= nil and type(location) ~= 'vector3' then
            postal = PostalsCache[source]
        end
        if Config.apiSendEnabled then
            local data = {
                name = caller, 
                location = location, 
                postal = postal,
                description  = description,
                gtaMapPosition  = {
                    x = playerCoords.x,
                    y = playerCoords.y,
                    z = playerCoords.z,
                    heading = 0
                }
            }
            debugLog("sending call!")
            performApiRequest(data, '911-calls','false', function() end)
        else
            debugPrint("[snailyCAD] API sending is disabled. Incoming call ignored.")
        end
    end)

    ---------------------------------
    -- Unit Panic
    ---------------------------------
    -- shared function to send panic signals
    function sendPanic(source)
        -- Determine identifier
        local identifier = GetIdentifiers(source)[Config.primaryIdentifier]
        -- Process panic POST request
        performApiRequest({{['isPanic'] = true, ['apiId'] = identifier}}, 'UNIT_PANIC', function() end)
    end

end