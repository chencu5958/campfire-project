------------------------------------------------- Game Require ------------------------------------------------------
local UDK = require("Public.UniX-SDK.main")
local Framework = require("Public.Framework.Main")
_G.UDK = UDK
_G.Framework = Framework

-- 游戏逻辑
local Gamelogic = require("Public.Gamelogic.Main")

------------------------------------------------- Game Life ---------------------------------------------------------

function OnBeginPlay()
    local Config = require("Public.Config.Main")
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
        TimerManager:AddLoopTimer(0.5, function()
            local content = UDK.Property.GetProperty("TEST", "Any", "EnvInfo")
            UDK.UI.SetUIText(100046, content)
        end)
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
