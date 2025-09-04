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
    if System:IsClient() then
        Gamelogic.Client.Init()
        TimerManager:AddLoopTimer(0.1, function()
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
