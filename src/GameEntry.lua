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
_G.UDK = require("Public.UniX-SDK.main")
_G.Config = require("Public.Config.Main")
_G.Framework = require("Public.Framework.Main")
_G.Gamelogic = require("Public.Gamelogic.Main")

------------------------------------------------- Game Life ---------------------------------------------------------

-- 监听玩家断线重连事件
System:RegisterEvent(Events.ON_PLAYER_RECONNECTED,
    function(playerID, levelID)
        --Gamelogic.Server.EventPlayerReconnectd(playerID, levelID)
    end
)

-- 监听玩家销毁角色事件
System:RegisterEvent(Events.ON_CHARACTER_DESTROYED,
    function(playerID)
        --Gamelogic.Server.EventPlayerDestory(playerID)
    end
)

-- 监听玩家受到致命伤害事件
System:RegisterEvent(Events.ON_CHARACTER_TAKE_FATAL_DAMAGE,
    function(playerID, killerID)
        --Gamelogic.Server.EventPlayerKilled(killerID, playerID)
    end
)

-- 监听玩家离开事件
System:RegisterEvent(Events.ON_PLAYER_PRELEAVE,
    function(playerID)
        --Gamelogic.Server.EventPlayerLeave(playerID)
    end
)

-- 监听玩家进入触发盒事件
System:RegisterEvent(Events.ON_CHARACTER_ENTER_SIGNAL_BOX,
    function(playerID, signalBoxID)
        --Gamelogic.Server.EventPlayerEnterSignalBox(playerID, signalBoxID)
    end
)

-- 监听玩家离开触发盒事件
System:RegisterEvent(Events.ON_CHARACTER_LEAVE_SIGNAL_BOX,
    function(playerID, signalBoxID)
        --Gamelogic.Server.EventPlayerLeaveSignalBox(playerID, signalBoxID)
    end
)

-- 监听生物死亡事件
System:RegisterEvent(Events.ON_CREATURE_KILLED,
    function(creatureID, killerID)
        --Gamelogic.Server.EventCreatureKilled(creatureID, killerID)
    end
)

-- 监听玩家受到伤害前事件
System:RegisterEvent(Events.ON_BEFORE_CHARACTER_TAKE_HURT,
    function(playerID, killerID, damage)
        --Gamelogic.Server.EventPlayerTakeHurt(playerID, killerID, damage)
    end
)

-- 监听生物受到伤害前事件
System:RegisterEvent(Events.ON_BEFORE_CREATURE_TAKING_DAMAGE,
    function(creatureID, killerID, damage)
        --Gamelogic.Server.EventCreatureTakeHurt(creatureID, killerID, damage)
    end
)

-- 监听脚本启动事件
System:RegisterEvent(Events.ON_BEGIN_PLAY, function()
    Framework.Common.Init.OnBeginPlay()
end)

-- 监听脚本结束事件
System:RegisterEvent(Events.ON_END_PLAY, function()
    Framework.Common.Init.OnEndPlay()
end)


-- 咕咕，IMUtils等后面引擎接口能操作原生聊天语音频道后就重构，现在的IMUtilsUI方案只是临时方案
