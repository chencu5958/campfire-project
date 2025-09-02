------------------------------------------------- Game Require ------------------------------------------------------
local UDK = require("Public.UniX-SDK.main")
_G.UDK = UDK
local Config = require("Public.Config.Main")
_G.Config = Config
local Framework = require("Public.Framework.Main")
_G.Framework = Framework
local Gamelogic = require("Public.Gamelogic.Main")
_G.Gamelogic = Gamelogic

------------------------------------------------- Game Life ---------------------------------------------------------

function OnBeginPlay()

    if System:IsServer() then
        TimerManager:AddLoopTimer(0.5, function()
            --local number = math.random(1, 100)
            --UDK.Property.SetProperty("TEST", "Any", "EnvInfo", "Connected")
            --local result = UDK.Property.GetProperty("TEST", "Any", "EnvInfo")
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
        end)
    end
end

function OnEndPlay()
    if System:IsClient() then
        Log:PrintLog("Client End")
    end
    if System:IsServer() then
        Log:PrintLog("Server End")
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
