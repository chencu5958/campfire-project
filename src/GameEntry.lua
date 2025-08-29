------------------------------------------------- Game Require ------------------------------------------------------
local UDK = require("Public.UniX-SDK.main")
local Framework = require("Public.Framework.Main")
local Config = require("Public.Config.Main")
local Gamelogic = require("Public.Gamelogic.Main")
_G.UDK = UDK
_G.Framework = Framework
_G.Config = Config
_G.Gamelogic = Gamelogic

------------------------------------------------- Game Life ---------------------------------------------------------

function OnBeginPlay()
    local parsedToml = UDK.TomlUtils.Parse(Config.Toml.I18N)
    local LangStr = parsedToml.i18n
    local str = UDK.I18N.I18NGetKey("language", "zh-CN", LangStr)

    if System:IsServer() then
        TimerManager:AddLoopTimer(0.5, function()
            local number = math.random(1, 100)
            --UDK.Property.SetProperty("TEST", "Any", "EnvInfo", "Connected")
            local result = UDK.Property.GetProperty("TEST", "Any", "EnvInfo")
            --Log:PrintLog(result)
            --UDK.Property.SyncAuthorityData(nil, "TEST", "Any", "EnvInfo", number)
            --Log:PrintLog(str)
            --Log:PrintTable(LangStr)
        end)
    end

    if System:IsClient() then
        Gamelogic.Client.Init()
        TimerManager:AddLoopTimer(0.1, function()
            local content = UDK.Property.GetProperty("TEST", "Any", "EnvInfo")
            UDK.UI.SetUIText(100046, content)
            Gamelogic.Client.Update()
        end)
    end

    if System:IsServer() then
        Gamelogic.Server.Init()
        TimerManager:AddLoopTimer(0.2, function()
            Gamelogic.Server.Update()
                    ServerLog("Server Log")
        end)
    end
end

function OnEndPlay()
    if System:IsClient() then
        Log:PrintLog("Client End")
    end
    if System:IsServer() then
        Log:PrintServerLog("Server End")
    end
end

-- 监听玩家断线重连事件
System:RegisterEvent(Events.ON_PLAYER_RECONNECTED,
    function(playerID, levelID)
        Gamelogic.Server.EventPlayerReconnectd(playerID, levelID)
    end
)

-- 监听脚本启动事件
System:RegisterEvent(Events.ON_BEGIN_PLAY, OnBeginPlay)

-- 监听脚本结束事件
System:RegisterEvent(Events.ON_END_PLAY, OnEndPlay)
