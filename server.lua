-- Load configuration
local Config = require('config')



Config = {}

-- Put Your Discord Webhook here

Config.WebhookURL = "YOUR_DISCORD_WEBHOOK_URL_HERE"



AddEventHandler('playerJoining', function()
    local webhookURL = Config.JoinWebhook
    local playerid = source
    local name = GetPlayerName(source)
    for k,v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = string.gsub(v, "discord:", "")
        end
    end
    local embedData = {
        {
            ["color"] = 8388736, 
            ["title"] = "Player Joined",
            ["description"] = "**Player Name**: ".. name .. " \n**Player ID**: ".. playerid .." \n**Discord**: <@".. discord .."> ",
            ["footer"] = {
                ["text"] = "Stealth's Development | Server Logs",
            },
        }
    }
    sendHttpRequest(webhookURL, {username = username, embeds = embedData})
end)

AddEventHandler('playerDropped', function(reason)
    local webhookURL = Config.LeaveWebhook
    local playerid = source
    local name = GetPlayerName(source)
    for k,v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = string.gsub(v, "discord:", "")
        end
    end
    local embedData = {
        {
            ["color"] = 255, 
            ["title"] = "Player Left",
            ["description"] = "**Player Name**: ".. name .. " \n**Player ID**: ".. playerid .." \n**Discord**: <@".. discord .."> \n**Reason**: " .. reason .."",
            ["footer"] = {
                ["text"] = "Stealth's Development | Server Logs",
            },
        }
    }
    sendHttpRequest(webhookURL, {username = username, embeds = embedData})
end)

AddEventHandler('chatMessage', function(source, name, msg)
    for k,v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = string.gsub(v, "discord:", "")
        end
    end  	
    local webhookURL = Config.ChatMsgWebhook
    local embedData = {
        {
            ["color"] = 8388736, 
            ["title"] = "Player Message",
            ["description"] = "**IGN**: " .. name .. " \n**Player ID**: " .. source .. " \n**Discord**: <@" .. discord .. "> \n**Chat Message**: " .. msg .. "",
            ["footer"] = {
                ["text"] = "Stealth's Development | Server Logs",
            },
        },
    }	
    sendHttpRequest(webhookURL, {username = username, embeds = embedData})
end)

RegisterServerEvent('playerDied')
AddEventHandler('playerDied', function(deathReason)
    local webhookURL = Config.DeathWebhook
    local player = GetPlayerName(source)
    local id = source
    local discord = ""
    
    for k,v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = string.gsub(v, "discord:", "")
        end
    end  	
    
    local embedData = {
        {
            ["color"] = 8388736, 
            ["title"] = "Player Death",
            ["description"] = "**IGN**: " .. player .. " \n**Player ID**: " .. id .. " \n**Discord**: <@" .. discord .. "> \n**Action**: " .. deathReason .."",
            ["footer"] = {
                ["text"] = "Stealth's Development | Server Logs",
            },
        },
    }	
    sendHttpRequest(webhookURL, {username = username, embeds = embedData})
end)

AddEventHandler('onResourceStop', function (resourceName)
    local webhookURL = Config.ResourceWebhook
    local embedData = {
        {
            ["color"] = 255, 
            ["title"] = "Resource Stopped",
            ["description"] = "**Folder Stopped**:".. resourceName .."",
            ["footer"] = {
                ["text"] = "Stealth's Development | Server Logs",
            },
        },
    }	
    sendHttpRequest(webhookURL, {username = username, embeds = embedData})
end)

AddEventHandler('onResourceStart', function (resourceName)
    Wait(100)
    local webhookURL = Config.ResourceWebhook
    local embedData = {
        {
            ["color"] = 255, 
            ["title"] = "Resource Stopped",
            ["description"] = "**Folder Stopped**:".. resourceName .."",
            ["footer"] = {
                ["text"] = "Stealth's Development | Server Logs",
            },
        },
    }	
    sendHttpRequest(webhookURL, {username = username, embeds = embedData})
end)

-- Function to send a message to the Discord webhook
function sendToDiscord(name, message, color)
    local embeds = {
        {
            ["title"] = Player ,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                ["text"] = "Stealth's Development | Server Logs"
            },
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Stealths Development | Server Logs", embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    sendToDiscord("Player Connecting", playerName .. " is connecting to the server.", 65280) -- Green color
end)

AddEventHandler('playerDropped', function(reason)
    local playerName = GetPlayerName(source)
    sendToDiscord("Player Disconnected", playerName .. " has left the server. Reason: " .. reason, 16711680) -- Red color
end)

AddEventHandler('playerdeath', function(reason)
    local PlayerName = GetPlayerName(source)
    sendToDiscord("Player Death", PlayerName .. " has Die. Reason: " .. reason, 16711680) -- Red color
end)