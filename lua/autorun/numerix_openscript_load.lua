--[[ OpenScript --------------------------------------------------------------------------------------

OpenScript made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

OpenScript = OpenScript or {}

OpenScript.Settings = OpenScript.Settings or {}
OpenScript.Language = OpenScript.Language or {}

local FileSystem = "openscript"
local AddonName = "OpenScript"
local Version = "1.0.4"
local FromWorkshop = false

if SERVER then

    MsgC( Color( 225, 20, 30 ), "\n-------------------------------------------------------------------\n")
    MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Version : "..Version.."\n")
    MsgC( Color( 225, 20, 30 ), "-------------------------------------------------------------------\n\n")

    for k, file in SortedPairs(file.Find(FileSystem.."/config/*", "LUA")) do
        include(FileSystem.."/config/"..file)
        AddCSLuaFile(FileSystem.."/config/"..file)
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/config/"..file.."\n")
    end

    for k, file in pairs (file.Find(FileSystem.."/client/*", "LUA")) do
        AddCSLuaFile(FileSystem.."/client/"..file)
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/client/"..file.."\n")
    end

    for k, file in pairs (file.Find(FileSystem.."/server/*", "LUA")) do
        include(FileSystem.."/server/"..file)
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/server/"..file.."\n")
    end
    
    for k, file in pairs (file.Find(FileSystem.."/languages/*", "LUA")) do
        AddCSLuaFile(FileSystem.."/languages/"..file)
        include(FileSystem.."/languages/"..file)
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/languages/"..file.."\n")
    end

    if FromWorshop then
        if OpenScript.Settings.VersionDefault != OpenScript.Settings.VersionCustom then
            hook.Add("PlayerInitialSpawn", "OpenScript:PlayerInitialSpawnCheckVersionConfig", function(ply)
                if ply:IsSuperAdmin() then
                    timer.Simple(10, function()
                        ply:OpenScriptChatInfo(OpenScript.GetLanguage("A new version of the config file is available. Please download it."), 1)
                    end)
                end
            end)
        end

        if OpenScript.Language.VersionDefault != OpenScript.Language.VersionCustom then
            hook.Add("PlayerInitialSpawn", "OpenScript:PlayerInitialSpawnCheckVersionLanguage", function(ply)
                if ply:IsSuperAdmin() then
                    timer.Simple(10, function()
                        ply:OpenScriptChatInfo(OpenScript.GetLanguage("A new version of the language file is available. Please download it."), 1)
                    end)
                end
            end)
        end
    end

    hook.Add("PlayerConnect", "OpenScript:Connect", function()
        if !game.SinglePlayer() then
            http.Post("https://gmod-radio-numerix.mtxserv.com/api/connect.php", { script = FileSystem, ip = game.GetIPAddress() }, 
            function(result)
                if result then 
                    MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Connection established\n") 
                end
            end, 
            function(failed)
                MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Connection failed : "..failed.."\n")
            end)
        end

        if !FromWorshop then
            http.Fetch( "https://gmod-radio-numerix.mtxserv.com/api/version/"..FileSystem..".txt",
                function( body, len, headers, code )
                    if body != Version then
                        hook.Add("PlayerInitialSpawn", "OpenScript:PlayerInitialSpawnCheckVersionAddon", function(ply)
                            if ply:IsSuperAdmin() then
                                timer.Simple(10, function()
                                    ply:OpenScriptChatInfo(OpenScript.GetLanguage("A new version of the addon is available. Please download it."), 1)
                                end)
                            end
                        end)
                    end 
                end,
                function( error )
                    MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Failed to retrieve version infomation\n") 
                end
            )
        end

        hook.Remove("PlayerConnect", "OpenScript:Connect")
    end)

    hook.Add("ShutDown", "OpenScript:Disconnect", function()
        if !game.SinglePlayer() then
            http.Post("https://gmod-radio-numerix.mtxserv.com/api/disconnect.php", { script = FileSystem, ip = game.GetIPAddress() }, 
            function(result)
                if result then 
                    MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Disconnection\n") 
                end
            end, 
            function(failed)
                MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Disconnection failed : "..failed.."\n")
            end)
        end
    end)

end

if CLIENT then

    for k, file in SortedPairs (file.Find(FileSystem.."/config/*", "LUA")) do
        include(FileSystem.."/config/"..file)
    end

    for k, file in pairs (file.Find(FileSystem.."/client/*", "LUA")) do
        include(FileSystem.."/client/"..file)
    end

    for k, file in pairs (file.Find(FileSystem.."/languages/*", "LUA")) do
        include(FileSystem.."/languages/"..file)
    end

end