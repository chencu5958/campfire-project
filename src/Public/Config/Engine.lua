-- ==================================================
-- * Campfire Project | Config/Engine.lua
-- *
-- * Info:
-- * Campfire Project Engine Config
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local EngineConf = {}

EngineConf.Core = {}

EngineConf.GameUI = {
    Init = {
        NativeInterfaceHidden = {
            "Promotion",
            "Countdown",
            "TargetPoints",
            "Leaderboard",
            "HealthBar",
            "Settings",
            "MapHint",
            "EmotesAndActions"
        },
    },
    UI = {
        MainMenuPID = {
            MyProfile = 1,
            Settings = 2,
            RankList = 3
        }
    }
}

EngineConf.AI = {}

-- 属性配置（1为类型，2为属性名称，3是默认值）
EngineConf.Property = {
    KeyMap = {
        PSetting = {
            Lang = { "String", "PSetting_Lang", "zh-CN" }
        },
        UIState = {
            MainMenu = { "Bool", "UIState_MainMenu", false },
            MainMenuOpenPID = { "Int", "UIState_MainMenuOpenPID", 0 },
            Taskbar = { "Bool", "UIState_Taskbar", false }
        },
        ServerState = {
            NameSpace = "ServerState",
            GameState = { "Map", "ServerState_GameState" }
        },
    }
}

return EngineConf
