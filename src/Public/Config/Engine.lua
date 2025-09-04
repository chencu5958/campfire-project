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
            "EmotesAndActions",
            "MoreSetting"
        },
    },
    UI = {
        MainMenuPID = {
            MyProfile = 1,
            Settings = 2,
            RankList = 3
        },
        Layout_SettingMisc = {
            Version = 1,
            Credits = 2,
            Feedback = 3
        }
    }
}

EngineConf.AI = {}

-- 属性配置（1为类型，2为属性名称，3是默认值）
EngineConf.Property = {
    KeyMap = {
        PSetting = {
            Lang = { "String", "PSetting_Lang", "zh-CN" },
            SFXSound = { "Boolean", "PSetting_SFXSound", true },
        },
        -- UIState全部由客户端的LightDMS管理，UDK Property不参与管理
        UIState = {
            MainMenuIsOpen = { "Boolean", "UIState_MainMenuIsOpen", false },
            MainMenuOpenPID = { "Number", "UIState_MainMenuOpenPID", 1 },
            LayoutSettingMiscPID = {  "Number", "UIState_LayoutSettingMiscPID", 1 },
            TaskbarIsOpen = { "Boolean", "UIState_TaskbarIsOpen", false }
        },
        ServerState = {
            NameSpace = "ServerState",
            GameState = { "Map", "ServerState_GameState" }
        },
    }
}

return EngineConf
