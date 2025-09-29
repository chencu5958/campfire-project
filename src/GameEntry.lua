-- ==================================================
-- * 咕噜咕噜，芝士可爱小猫
-- * ⣿⣿⣿⣿⣿⣿⡿⣛⣭⣭⣛⢿⣿⣿⣿⣿⣿⣿⣿⣿⢟⣫⣭⣭⡻⣿⣿⣿⣿⣿
-- * ⣿⣿⣿⣿⡿⢫⣾⣿⠿⢿⣛⣓⣪⣭⣭⣭⣭⣭⣭⣕⣛⡿⢿⣿⣿⣎⢿⣿⣿⣿
-- * ⣿⣿⣿⡿⣱⢟⣫⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣮⣙⢿⡎⣿⣿⣿
-- * ⣿⣿⣿⢑⣵⣿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢿⣷⣌⢸⣿⣿
-- * ⣿⣿⢣⣿⠟⠁⠄⠄⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠄⠄⠙⣿⣧⢻⣿
-- * ⣿⢧⣿⡏⠄⠄⠄⠄⣸⣿⣿⡟⣛⣛⣫⣬⣛⣛⢫⣿⣿⡇⠄⠄⠄⠄⣿⣿⡇⣿
-- * ⣿⢸⣿⣧⡀⠄⠄⣰⣿⣿⣿⣧⢻⣿⣿⣿⣿⣿⢣⣿⣿⣿⣄⡀⠄⣠⣿⣿⣿⢹
-- * ⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡜⣿⣿⣿⣿⡟⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸
-- * ⣿⡸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣭⣉⣭⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢇⣿
-- * ⣿⣧⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⣼⣿
-- ==================================================

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

-- 监听玩家销毁角色事件
System:RegisterEvent(Events.ON_CHARACTER_DESTROYED,
    function(playerID)
        Gamelogic.Server.EventPlayerDestory(playerID)
    end
)

-- 监听玩家受到致命伤害事件
System:RegisterEvent(Events.ON_CHARACTER_TAKE_FATAL_DAMAGE,
    function(playerID, killerID)
        Gamelogic.Server.EventPlayerKilled(killerID, playerID)
    end
)

-- 监听玩家离开事件
System:RegisterEvent(Events.ON_PLAYER_PRELEAVE,
    function(playerID)
        Gamelogic.Server.EventPlayerLeave(playerID)
        print("OnPlayerPreLeave", playerID)
    end
)

-- 监听玩家进入触发盒事件
System:RegisterEvent(Events.ON_CHARACTER_ENTER_SIGNAL_BOX,
    function(playerID, signalBoxID)
        print("OnCharacterEnterSignalBox", playerID, signalBoxID)
    end
)

-- 监听玩家离开触发盒事件
System:RegisterEvent(Events.ON_CHARACTER_LEAVE_SIGNAL_BOX,
    function(playerID, signalBoxID)
        print("OnCharacterLeaveSignalBox", playerID, signalBoxID)
    end
)

-- 监听生物死亡事件
System:RegisterEvent(Events.ON_CREATURE_KILLED,
    function(creatureID, killerID)
        Gamelogic.Server.EventCreatureKilled(creatureID, killerID)
    end
)

-- 监听脚本启动事件
System:RegisterEvent(Events.ON_BEGIN_PLAY, OnBeginPlay)

-- 监听脚本结束事件
System:RegisterEvent(Events.ON_END_PLAY, OnEndPlay)


-- 咕咕，IMUtils等后面引擎接口能操作原生聊天语音频道后就重构，现在的IMUtilsUI方案只是临时方案
